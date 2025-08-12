# store_analysis
SQL-based project for data cleaning, transformation, and business insights from sales transactions.
# 📂 Dataset Information
The dataset (sales_store) includes the following key columns:
transaction_id – Unique identifier for each transaction
customer_id, customer_name, customer_age, gender – Customer details
product_id, product_name, product_category – Product details
Quantity, price – Order details
payment_mode – Payment method used
purchase_date, time_of_purchase – Transaction timestamp
status – Order status (delivered, cancelled, returned)
# 🛠 Data Cleaning Steps
Removed duplicates based on transaction_id
Renamed columns for clarity (quantiy → quantity, prce → price)
Checked and updated data types for accuracy
Handled NULL values by deleting invalid rows or updating missing data
Standardized values for columns like gender and payment_mode
#  Analysis Performed
# 1️ Top 5 Most Selling Products
Helps identify products in high demand for inventory planning.
# 2️ Most Frequently Cancelled Products
Detects products with high cancellation rates for quality or marketing review.
# 3️ Peak Purchase Time
Reveals busiest times for better staffing and promotions.
# 4️ Highest Spending Customers
Identifies VIP customers for loyalty programs.
# 5️ Top Revenue-Generating Product Categories
Supports product strategy and investment decisions.
# 6️ Cancellation & Return Rate by Category
Helps monitor dissatisfaction trends.
# 7️ Preferred Payment Modes
Streamlines payment processing by prioritizing popular methods.
# 8️ Purchasing Behavior by Age Group
Guides targeted marketing campaigns.
# 9️ Monthly Sales Trends
Aids seasonal inventory and marketing planning.
# 10 Gender-Based Product Preferences
Supports personalized recommendations and ad targeting.
# 📈 Business Impact
Improved inventory management by identifying high-demand products
Reduced losses by detecting high-cancellation products
Better marketing decisions through customer demographic analysis
Increased customer retention via targeted offers
