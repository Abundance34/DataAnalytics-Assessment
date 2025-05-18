## This repository offers SQL solutions for the Data Analyst Assessment problems. The following are explanations for each question and problem encountered during the procedure.
## **Question 1: High-Value Customers with Multiple Products**
### Approach
 **Identify Funded Plans**: To make sure that only funded plans (transactions with `confirmed_amount > 0`) are counted, `plans_plan` and `savings_savingsaccount` were joined.
 **Count Savings/Investment Plans**: To prevent double-counting transactions under the same plan, `COUNT(DISTINCT...)` was used.
**Calculate Total Deposits**: The total deposits were calculated by converting kobo to a major currency and aggregating the `confirmed_amount` from savings accounts.
**Filter and Sort**: Sorted by `total_deposits` after applying `HAVING` to guarantee that clients have ≥1 savings and investment plan.
### Challenges:
- Initially, inaccurate counts resulted from failing to check `confirmed_amount` for funded status.
- In order to filter financed transactions, a join condition was added.
  
## **Question 2: Transaction Frequency Analysis**
### Approach 
**Include All Customers**: Begin with 'users_customuser' and use a 'LEFT JOIN' to include customers with no transactions.
 **Calculate Active Months**: Use 'DATEDIFF' and 'CEIL' to treat partial months as complete months.
 **Categorize Frequency**: Using a 'CASE' statement, consumers were classified as High, Medium, or Low Frequency based on average monthly transactions.
 **Handle Edge Cases**: Included 'COALESCE' and 'GREATEST' to avoid division by zero for inactive users.
 ### Challenges 
- Initially, the month was calculated incorrectly using 'TIMESTAMPDIFF'. Fixed by changing to 'DATEDIFF'.
- Ensuring that idle users (zero transactions) were classified as "low frequency."

## **Question 3: Account Inactivity Alert**
### Approach
**Track Last Inflow Date**: To track the final inflow date, combine 'deposit_date' (savings) and 'last_charge_date' (investments) with 'GREATEST'.
 **Fallback to Plan Creation Date**: For plans with no transactions, 'created_date' was set as the default.
 **Filter Active Accounts**: Included only plans with'status_id = 1' (active).
 **Calculate Inactivity Days**: Using 'DATEDIFF', compare the latest inflow date to the present date.
 ### Challenges
 - Managing plans without transactions. Solved by using 'created_date' as a fallback.
- Only financed transactions ('confirmed_amount > 0') were examined.

## **Question 4: Customer Lifetime Value (CLV) Estimation**
### Approach 
 **Calculate Tenure**: Use 'TIMESTAMPDIFF' to calculate the exact months since signup.
 **Aggregate Transactions**: Counted all transactions and averaged the 'confirmed_amount'.
**Compute CLV**: Use the formula '(total_transactions/tenure) * 12 * (avg_txn_value * 0.001)'.
**Handle Edge Cases**: For users that have no transactions or tenure, set 'CLV = 0'.
### Challenges: 
- Overcounting tenure with '+1'. Fixed by deleting the offset.
- Handling NULL values for inactive users using 'COALESCE'.

