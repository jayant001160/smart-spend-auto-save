const User = require("../models/User");

const upsertUserProfile = async (req, res, next) => {
  try {
    const { monthlyIncome, monthlyBudget } = req.body;

    if (!monthlyIncome || Number(monthlyIncome) <= 0) {
      return res.status(400).json({
        success: false,
        message: "Monthly income must be greater than 0"
      });
    }

    const existingUser = await User.findOne().sort({ createdAt: 1 });
    if (existingUser) {
      existingUser.monthlyIncome = Number(monthlyIncome);
      if (monthlyBudget !== undefined) {
        existingUser.monthlyBudget = Number(monthlyBudget);
      }
      const updatedUser = await existingUser.save();
      return res.status(200).json({
        success: true,
        message: "User profile updated",
        data: updatedUser
      });
    }

    const createdUser = await User.create({
      monthlyIncome: Number(monthlyIncome),
      monthlyBudget: monthlyBudget !== undefined ? Number(monthlyBudget) : undefined
    });

    return res.status(201).json({
      success: true,
      message: "User profile created",
      data: createdUser
    });
  } catch (error) {
    return next(error);
  }
};

const getUserProfile = async (req, res, next) => {
  try {
    const user = await User.findOne().sort({ createdAt: 1 });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User profile not found"
      });
    }

    return res.status(200).json({
      success: true,
      data: user
    });
  } catch (error) {
    return next(error);
  }
};

module.exports = {
  upsertUserProfile,
  getUserProfile
};
