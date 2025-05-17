WITH customer_plan_counts AS (
  SELECT
    p.owner_id,
    -- Count funded savings plans (confirmed_amount > 0)
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.id END) AS savings_count,
    -- Count funded investment plans (confirmed_amount > 0)
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.id END) AS investment_count
  FROM
    plans_plan p
    JOIN savings_savingsaccount s ON p.id = s.plan_id
  WHERE
    s.confirmed_amount > 0 -- Ensure the plan is funded
  GROUP BY
    p.owner_id
  HAVING
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.id END) >= 1
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.id END) >= 1
),
customer_deposits AS (
  SELECT
    owner_id,
    SUM(confirmed_amount) / 100.0 AS total_deposits -- Convert kobo to major currency
  FROM
    savings_savingsaccount
  GROUP BY
    owner_id
)
SELECT
  c.owner_id,
  CONCAT(u.first_name, ' ', u.last_name) AS name,
  c.savings_count,
  c.investment_count,
  COALESCE(d.total_deposits, 0) AS total_deposits
FROM
  customer_plan_counts c
  JOIN users_customuser u ON u.id = c.owner_id
  LEFT JOIN customer_deposits d ON d.owner_id = c.owner_id
ORDER BY
  total_deposits DESC;
