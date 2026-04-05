const Expense = require("../models/Expense");
const Goal = require("../models/Goal");
const User = require("../models/User");
const {
  getWeeklyAutoSaveRecommendation,
  getMonthRange,
  getWeekRange,
  getPreviousWeekRange,
  sumExpensesInRange
} = require("../services/recommendationService");
const { getAlerts } = require("../services/alertService");

const getDashboardSummary = async (req, res, next) => {
  try {
    const user = await User.findOne().sort({ createdAt: 1 });
    const goal = await Goal.findOne().sort({ createdAt: 1 });

    const { monthStart, monthEnd } = getMonthRange();
    const currentWeek = getWeekRange();
    const previousWeek = getPreviousWeekRange();

    const [monthlySpend, weeklySpend, previousWeeklySpend] = await Promise.all([
      sumExpensesInRange(monthStart, monthEnd),
      sumExpensesInRange(currentWeek.start, currentWeek.end),
      sumExpensesInRange(previousWeek.start, previousWeek.end)
    ]);

    const categoryData = await Expense.aggregate([
      { $match: { date: { $gte: monthStart, $lt: monthEnd } } },
      { $group: { _id: "$category", total: { $sum: "$amount" } } }
    ]);

    const categoryBreakdown = categoryData.reduce((acc, item) => {
      acc[item._id] = item.total;
      return acc;
    }, {});

    const monthlyBudget = user ? user.monthlyBudget || user.monthlyIncome : 0;
    const remainingBudget = Math.max(0, monthlyBudget - monthlySpend);

    const goalProgress = goal
      ? Math.min(100, Math.round(((goal.savedAmount || 0) / goal.targetAmount) * 100))
      : 0;

    const recommendation = await getWeeklyAutoSaveRecommendation();
    const alerts = getAlerts({ categoryBreakdown, monthlySpend, user });

    const insights = [];
    if (previousWeeklySpend > 0 && weeklySpend > previousWeeklySpend) {
      const increasePct = Math.round(((weeklySpend - previousWeeklySpend) / previousWeeklySpend) * 100);
      insights.push(`Weekly spend is ${increasePct}% higher than last week`);
    }

    if (user) {
      insights.push(`You can still save INR ${Math.round(remainingBudget)} this month`);
    }

    insights.push(`Recommended auto-save this week: INR ${recommendation.amount}`);
    insights.push(...alerts);

    if (user) {
      const budgetUsagePct = monthlyBudget > 0
        ? Math.round((monthlySpend / monthlyBudget) * 100)
        : 0;
      insights.push(`You have used ${budgetUsagePct}% of this month's budget so far`);
    }

    if (goal) {
      const remainingGoalAmount = Math.max(0, goal.targetAmount - (goal.savedAmount || 0));
      insights.push(`INR ${Math.round(remainingGoalAmount)} left to reach your goal "${goal.goalName}"`);
    }

    while (insights.length < 3) {
      insights.push("Track daily expenses consistently to improve recommendation accuracy.");
    }

    return res.status(200).json({
      success: true,
      data: {
        weeklySpend: Math.round(weeklySpend),
        monthlySpend: Math.round(monthlySpend),
        remainingBudget: Math.round(remainingBudget),
        goalProgress,
        categoryBreakdown,
        recommendedSave: recommendation.amount,
        insights
      }
    });
  } catch (error) {
    return next(error);
  }
};

module.exports = {
  getDashboardSummary
};
