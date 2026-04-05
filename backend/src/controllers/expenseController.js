const mongoose = require("mongoose");
const Expense = require("../models/Expense");

const createExpense = async (req, res, next) => {
  try {
    const { amount, category, merchant, date, paymentMode, notes, requestId } = req.body;

    if (!amount || Number(amount) <= 0) {
      return res.status(400).json({
        success: false,
        message: "Amount must be positive"
      });
    }

    if (!category || !String(category).trim()) {
      return res.status(400).json({
        success: false,
        message: "Category is required"
      });
    }

    if (!merchant || !String(merchant).trim()) {
      return res.status(400).json({
        success: false,
        message: "Merchant is required"
      });
    }

    if (!requestId || !String(requestId).trim()) {
      return res.status(400).json({
        success: false,
        message: "requestId is required"
      });
    }

    const expenseDate = new Date(date);
    if (Number.isNaN(expenseDate.getTime())) {
      return res.status(400).json({
        success: false,
        message: "Invalid expense date"
      });
    }

    if (expenseDate > new Date()) {
      return res.status(400).json({
        success: false,
        message: "Future dates are not allowed"
      });
    }

    const existingByRequestId = await Expense.findOne({ requestId: String(requestId).trim() });
    if (existingByRequestId) {
      return res.status(200).json({
        success: true,
        message: "Duplicate requestId detected. Returning existing expense.",
        data: existingByRequestId
      });
    }

    const expense = await Expense.create({
      amount: Number(amount),
      category: String(category).trim(),
      merchant: String(merchant).trim(),
      date: expenseDate,
      paymentMode,
      notes,
      requestId: String(requestId).trim()
    });

    return res.status(201).json({
      success: true,
      message: "Expense created",
      data: expense
    });
  } catch (error) {
    if (error && error.code === 11000 && error.keyPattern && error.keyPattern.requestId) {
      const existing = await Expense.findOne({ requestId: req.body.requestId });
      return res.status(200).json({
        success: true,
        message: "Duplicate requestId detected. Returning existing expense.",
        data: existing
      });
    }
    return next(error);
  }
};

const getExpenses = async (req, res, next) => {
  try {
    const expenses = await Expense.find().sort({ date: -1, createdAt: -1 });
    return res.status(200).json({
      success: true,
      data: expenses
    });
  } catch (error) {
    return next(error);
  }
};

const updateExpense = async (req, res, next) => {
  try {
    const { id } = req.params;
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        message: "Invalid expense ID"
      });
    }

    if (req.body.amount !== undefined && Number(req.body.amount) <= 0) {
      return res.status(400).json({
        success: false,
        message: "Amount must be positive"
      });
    }

    if (req.body.date !== undefined) {
      const date = new Date(req.body.date);
      if (Number.isNaN(date.getTime())) {
        return res.status(400).json({
          success: false,
          message: "Invalid expense date"
        });
      }
      if (date > new Date()) {
        return res.status(400).json({
          success: false,
          message: "Future dates are not allowed"
        });
      }
    }

    const expense = await Expense.findByIdAndUpdate(id, req.body, {
      new: true,
      runValidators: true
    });

    if (!expense) {
      return res.status(404).json({
        success: false,
        message: "Expense not found"
      });
    }

    return res.status(200).json({
      success: true,
      message: "Expense updated",
      data: expense
    });
  } catch (error) {
    return next(error);
  }
};

const deleteExpense = async (req, res, next) => {
  try {
    const { id } = req.params;
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        message: "Invalid expense ID"
      });
    }

    const deletedExpense = await Expense.findByIdAndDelete(id);
    if (!deletedExpense) {
      return res.status(404).json({
        success: false,
        message: "Expense not found"
      });
    }

    return res.status(200).json({
      success: true,
      message: "Expense deleted"
    });
  } catch (error) {
    return next(error);
  }
};

module.exports = {
  createExpense,
  getExpenses,
  updateExpense,
  deleteExpense
};
