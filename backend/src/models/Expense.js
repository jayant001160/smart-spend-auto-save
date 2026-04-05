const mongoose = require("mongoose");

const expenseSchema = new mongoose.Schema(
  {
    amount: {
      type: Number,
      required: true,
      min: [1, "Amount must be positive"]
    },
    category: {
      type: String,
      required: [true, "Category is required"],
      trim: true
    },
    merchant: {
      type: String,
      required: [true, "Merchant is required"],
      trim: true
    },
    date: {
      type: Date,
      required: [true, "Date is required"]
    },
    paymentMode: {
      type: String,
      required: [true, "Payment mode is required"],
      trim: true
    },
    notes: {
      type: String,
      trim: true
    },
    requestId: {
      type: String,
      required: [true, "requestId is required"],
      unique: true,
      trim: true
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("Expense", expenseSchema);
