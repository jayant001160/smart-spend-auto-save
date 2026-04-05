const getAlerts = ({ categoryBreakdown, monthlySpend, user }) => {
  const alerts = [];

  if (!user) {
    return alerts;
  }

  const monthlyBudget = user.monthlyBudget || user.monthlyIncome;

  if (monthlyBudget > 0) {
    Object.entries(categoryBreakdown).forEach(([category, total]) => {
      if (total >= monthlyBudget * 0.8) {
        alerts.push(
          `${category} spending has exceeded 80% of your monthly budget. Consider reducing this category.`
        );
      }
    });
  }

  const discretionaryCap = user.monthlyIncome * 0.9;
  if (monthlySpend > discretionaryCap) {
    alerts.push(
      "Monthly discretionary spending is too high compared to your income. Consider tightening expenses."
    );
  }

  return alerts;
};

module.exports = {
  getAlerts
};
