const express = require("express");
const cors = require("cors");

const userRoutes = require("./routes/userRoutes");
const expenseRoutes = require("./routes/expenseRoutes");
const goalRoutes = require("./routes/goalRoutes");
const dashboardRoutes = require("./routes/dashboardRoutes");
const recommendationRoutes = require("./routes/recommendationRoutes");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/user", userRoutes);
app.use("/api/expenses", expenseRoutes);
app.use("/api/goal", goalRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/recommendation", recommendationRoutes);

app.use((req, res) => {
  return res.status(404).json({
    success: false,
    message: "Route not found"
  });
});

app.use((error, req, res, next) => {
  if (error && error.name === "ValidationError") {
    const firstError = Object.values(error.errors)[0];
    return res.status(400).json({
      success: false,
      message: firstError ? firstError.message : "Validation failed"
    });
  }

  if (error && error.name === "CastError") {
    return res.status(400).json({
      success: false,
      message: "Invalid identifier or value format"
    });
  }

  if (error && error.code === 11000 && error.keyPattern && error.keyPattern.requestId) {
    return res.status(409).json({
      success: false,
      message: "Duplicate requestId"
    });
  }

  return res.status(500).json({
    success: false,
    message: error && error.message ? error.message : "Internal server error"
  });
});

module.exports = app;
