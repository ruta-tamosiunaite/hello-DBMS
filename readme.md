# Project hello-DBMS #

To launch the Flask app, install Flask and sqlite3, then run app.py and go to http://127.0.0.1:5000/

## A. What is Data?

Data refers to distinct pieces of information, usually formatted and stored in a way that is concordant with a specific purpose. It can represent qualitative or quantitative attributes and can come in various forms. The primary aim of data is to provide insight or information.

### Forms of Data:

1. **Structured Data**: This is highly organized and easily understood by machine language, typically stored in well-defined schemas like databases. For example, names, dates, addresses, credit card numbers, stock information, geolocation, etc.

2. **Unstructured Data**: This is information that doesn't have a pre-defined model or isn't organized in a pre-defined manner. It's often text-heavy and may contain dates, numbers, and facts. For example, books, journals, emails, social media posts, videos, images, and audio files.

3. **Semi-structured Data**: This type of data doesn't reside in a relational database but does have some organizational properties that make it easier to analyze. It might have metadata or tags. Examples include XML files, JSON documents, and certain types of data from NoSQL databases.

4. **Quantitative Data**: This is numerical data, anything that can be measured and written down with numbers. For instance, this can include statistical data, measurements, counts, or percentages.

5. **Qualitative Data**: This is descriptive data and concerns properties and attributes that can't be measured directly with numbers but can be observed qualitatively. Examples include survey responses, interview transcripts, and descriptive phrases.

Data is crucial for analysis, making informed decisions, and formulating strategies in various domains, including science, business, healthcare, and more.

### References:
- "What is Data?" - [IBM](https://www.ibm.com/cloud/learn/what-is-data)
- "Understanding Structured, Unstructured, and Semi Structured Data" - [DataFlair](https://data-flair.training/blogs/structured-unstructured-semi-structured-data/)


## B. Criteria for Measuring Data Quality

Data quality is vital for ensuring reliable analytics and decision-making. Six common dimensions are used to measure the quality of data:

1. **Accuracy**: Reflects how closely data represents the true values. Accurate data correctly depicts the real-world scenario it represents.

2. **Completeness**: Ensures that no critical data is missing and all necessary information is present in the dataset.

3. **Consistency**: Data remains the same across different datasets and systems. Consistent data does not contradict itself and provides uniform results.

4. **Timeliness**: Evaluates whether data is up-to-date and available when required. It should reflect the most current situation for its intended use.

5. **Reliability**: Data is considered reliable if it can be depended upon for its accuracy and consistency over time. It comes from a reputable source and provides the same results under consistent conditions.

6. **Uniqueness**: Each data element is unique and not duplicated within the dataset. This ensures the dataset is clean, and each entry is distinct.

### Importance of Data Quality:

Maintaining high-quality data is essential for accurate decision-making and operational efficiency. Low-quality data can lead to incorrect conclusions, wasted resources, and decreased trust in data systems.

### References:
- "What is Data Quality and Why is it Important?" - [Talend](https://www.talend.com/resources/what-is-data-quality/)
- "The Six Primary Dimensions for Data Quality Assessment" - [MIT Information Quality](http://web.mit.edu/tdqm/www/tdqmpub/LongeneckerPQ.PDF)



## C. Data Lake vs. Data Warehouse vs. Lake House

| Criteria        | Data Lake                                      | Data Warehouse                                  | Lake House                                      |
|-----------------|------------------------------------------------|-------------------------------------------------|-------------------------------------------------|
| **Definition**  | A centralized repository for all types of data, both structured and unstructured, at any scale. | A system optimized for analyzing and reporting structured, processed data. | A hybrid model combining the flexibility of a Data Lake with the management of a Data Warehouse. |
| **Characteristics** | - Stores raw, unstructured data.<br>- Schema-on-read.<br>- Ideal for big data and real-time analytics. | - Stores processed, structured data.<br>- Schema-on-write.<br>- Ideal for historical data analysis and business intelligence. | - Combines features of Data Lakes and Warehouses.<br>- Supports raw and processed data.<br>- Offers data management and ACID transactions. |
| **Flexibility** | Most flexible, accepts all types of data. | Less flexible, requires pre-defined schemas. | Provides a middle ground with flexible storage and management. |
| **Data Quality** | May contain raw, unverified data. | Often has higher data quality due to processing and structuring. | Maintains a balance with data management features. |
| **Use Case**    | Ideal for big data processing and data science. | Best for structured reporting and business intelligence. | Versatile, catering to both analytics and operational purposes. |

### References:
- "Data Lake vs. Data Warehouse" - [AWS](https://aws.amazon.com/big-data/datalakes-and-analytics/what-is-a-data-lake/)
- "What is a Data Lakehouse?" - [Databricks](https://databricks.com/glossary/data-lakehouse)


## D. Database Management Systems (DBMS)

### Definition:
A Database Management System (DBMS) is software designed to store, manipulate, and retrieve data efficiently and securely. It provides the necessary tools to create, manage, and interact with one or more databases.

### Comparison of DBMS:

| DBMS         | Description                                                                                                            | Illustration                          | Source                                    |
|--------------|------------------------------------------------------------------------------------------------------------------------|---------------------------------------|-------------------------------------------|
| **MySQL**    | MySQL is an open-source relational database management system, very popular for web applications.                        | ![MySQL Logo](https://example.com/mysql_logo.png) | [Official MySQL Site](https://www.mysql.com/) |
| **PostgreSQL**| PostgreSQL is an advanced, open-source relational DBMS, focusing on standards and extensibility.                        | ![PostgreSQL Logo](https://example.com/postgresql_logo.png) | [Official PostgreSQL Site](https://www.postgresql.org/) |
| **MongoDB**  | MongoDB is a NoSQL document-oriented DBMS offering high flexibility and performance for applications with large data volumes. | ![MongoDB Logo](https://example.com/mongodb_logo.png) | [Official MongoDB Site](https://www.mongodb.com/) |
| **Oracle Database** | Oracle Database is a powerful and comprehensive relational DBMS used for large enterprise applications.               | ![Oracle Logo](https://example.com/oracle_logo.png) | [Official Oracle Site](https://www.oracle.com/database/) |

### References:
- "Introduction to Databases" - [Oracle](https://www.oracle.com/database/what-is-database.html)
- "Choosing a Database" - [AWS](https://aws.amazon.com/products/databases/)

