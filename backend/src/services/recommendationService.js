const Expense = require("../models/Expense");
const Goal = require("../models/Goal");
const User = require("../models/User");

const ONE_DAY_MS = 24 * 60 * 60 * 1000;

const getMonthRange = (date = new Date()) => {
  const monthStart = new Date(date.getFullYear(), date.getMonth(), 1);
  const monthEnd = new Date(date.getFullYear(), date.getMonth() + 1, 1);
  return { monthStart, monthEnd };
};

const getWeekRange = (date = new Date()) => {
  const end = new Date(date);
  end.setHours(23, 59, 59, 999);

  const start = new Date(date.getTime() - 6 * ONE_DAY_MS);
  start.setHours(0, 0, 0, 0);

  return { start, end };
};

const getPreviousWeekRange = (date = new Date()) => {
  const currentWeek = getWeekRange(date);
  const end = new Date(currentWeek.start.getTime() - ONE_DAY_MS);
  end.setHours(23, 59, 59, 999);

  const start = new Date(end.getTime() - 6 * ONE_DAY_MS);
  start.setHours(0, 0, 0, 0);

  return { start, end };
};

const sumExpensesInRange = async (start, end) => {
  const result = await Expense.aggregate([
    { $match: { date: { $gte: start, $lt: end } } },
    { $group: { _id: null, total: { $sum: "$amount" } } }
  ]);
  return result[0] ? result[0].total : 0;
};

const calculateMonthsLeft = (targetDate) => {
  const now = new Date();
  const yearDiff = targetDate.getFullYear() - now.getFullYear();
  const monthDiff = targetDate.getMonth() - now.getMonth();
  const totalMonths = yearDiff * 12 + monthDiff + (targetDate.getDate() >= now.getDate() ? 1 : 0);
  return Math.max(1, totalMonths);
};

const getWeeklyAutoSaveRecommendation = async () => {
  const user = await User.findOne().sort({ createdAt: -1 });
  const goal = await Goal.findOne().sort({ createdAt: -1 });

  if (!user) {
    return {
      amount: 0,
      reason: "No user profile found. Add monthly income to enable recommendations."
    };
  }

  if (!goal) {
    return {
      amount: 0,
      reason: "No savings goal found. Create a goal to receive recommendations."
    };
  }

  const { monthStart, monthEnd } = getMonthRange();
  const monthlySpend = await sumExpensesInRange(monthStart, monthEnd);

  const remainingGoal = Math.max(0, goal.targetAmount - (goal.savedAmount || 0));
  const monthsLeft = calculateMonthsLeft(new Date(goal.targetDate));

  const weeklyTarget = remainingGoal / monthsLeft / 4;
  const disposableIncome = Math.max(0, user.monthlyIncome - monthlySpend);
  const maxSafeWeeklySave = (disposableIncome * 0.25) / 4;

  let recommendation = Math.min(weeklyTarget, maxSafeWeeklySave);
  let reason = "Balanced between goal timeline and disposable income.";

  const currentWeek = getWeekRange();
  const previousWeek = getPreviousWeekRange();
  const [thisWeekSpend, lastWeekSpend] = await Promise.all([
    sumExpensesInRange(currentWeek.start, currentWeek.end),
    sumExpensesInRange(previousWeek.start, previousWeek.end)
  ]);

  if (lastWeekSpend > 0 && thisWeekSpend > lastWeekSpend * 1.25) {
    recommendation *= 0.8;
    reason = "Reduced due to spending spike.";
  }

  return {
    amount: Math.max(0, Math.round(recommendation)),
    reason
  };
};

module.exports = {
  getWeeklyAutoSaveRecommendation,
  getMonthRange,
  getWeekRange,
  getPreviousWeekRange,
  sumExpensesInRange
};
