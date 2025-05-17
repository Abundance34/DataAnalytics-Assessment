WITH last_inflow AS (
  SELECT
    p.id AS plan_id,
    p.owner_id,
    GREATEST(
      MAX(s.deposit_date),          -- This is the Last savings deposit
      MAX(p.last_charge_date),      -- This is the Last investment charge
      p.created_date                -- This is the Fallback to plan creation date
    ) AS last_inflow_date
  FROM
    plans_plan p
    LEFT JOIN savings_savingsaccount s 
      ON p.id = s.plan_id AND s.confirmed_amount > 0 -- Inflow deposits only
  WHERE
    p.status_id = 1 -- Active accounts only
  GROUP BY
    p.id, p.owner_id, p.created_date
)
SELECT
  l.plan_id,
  l.owner_id,
  CASE
    WHEN p.is_regular_savings = 1 THEN 'Savings'
    WHEN p.is_a_fund = 1 THEN 'Investment'
    ELSE 'Other'
  END AS type,
  l.last_inflow_date AS last_transaction_date,
  DATEDIFF(CURDATE(), l.last_inflow_date) AS inactivity_days
FROM
  last_inflow l
  JOIN plans_plan p ON l.plan_id = p.id
WHERE
  DATEDIFF(CURDATE(), l.last_inflow_date) > 365
ORDER BY
  inactivity_days DESC;
