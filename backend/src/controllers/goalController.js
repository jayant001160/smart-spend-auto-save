const Goal = require("../models/Goal");

const upsertGoal = async (req, res, next) => {
  try {
    const { goalName, targetAmount, targetDate, savedAmount } = req.body;

    if (!targetAmount || Number(targetAmount) <= 0) {
      return res.status(400).json({
        success: false,
        message: "Target amount must be greater than 0"
      });
    }

    const parsedTargetDate = new Date(targetDate);
    if (Number.isNaN(parsedTargetDate.getTime())) {
      return res.status(400).json({
        success: false,
        message: "Invalid target date"
      });
    }

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    parsedTargetDate.setHours(0, 0, 0, 0);
    if (parsedTargetDate < today) {
      return res.status(400).json({
        success: false,
        message: "Target date must not be in the past"
      });
    }

    let goal = await Goal.findOne().sort({ createdAt: 1 });
    if (goal) {
      goal.goalName = goalName || goal.goalName;
      goal.targetAmount = Number(targetAmount);
      goal.targetDate = new Date(targetDate);
      if (savedAmount !== undefined) {
        goal.savedAmount = Number(savedAmount);
      }
      goal = await goal.save();

      return res.status(200).json({
        success: true,
        message: "Savings goal updated",
        data: goal
      });
    }

    goal = await Goal.create({
      goalName,
      targetAmount: Number(targetAmount),
      targetDate: new Date(targetDate),
      savedAmount: savedAmount !== undefined ? Number(savedAmount) : undefined
    });

    return res.status(201).json({
      success: true,
      message: "Savings goal created",
      data: goal
    });
  } catch (error) {
    return next(error);
  }
};

const getGoal = async (req, res, next) => {
  try {
    const goal = await Goal.findOne().sort({ createdAt: 1 });

    if (!goal) {
      return res.status(404).json({
        success: false,
        message: "Savings goal not found"
      });
    }

    return res.status(200).json({
      success: true,
      data: goal
    });
  } catch (error) {
    return next(error);
  }
};

module.exports = {
  upsertGoal,
  getGoal
};
