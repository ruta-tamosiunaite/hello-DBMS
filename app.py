from flask import Flask, request, render_template
import sqlite3
from collections import deque

app = Flask(__name__)

# Initialize a deque to store the query history with a fixed length
query_history = deque(maxlen=100)  # Adjust maxlen as needed

def get_findings(query, request_text):
    conn = sqlite3.connect('data/CarbonFootprint.db')
    cursor = conn.cursor()
    
    cursor.execute(query)
    results = cursor.fetchall()
    headers = [description[0] for description in cursor.description]
    
    if results:
        first_result = results[0][0]
        cursor.execute('SELECT ROUND(SUM(Contribution), 2) AS Total_Contribution FROM CountryEmissionsView WHERE Country = ?;', (first_result,))
        total_emissions = cursor.fetchone()[0]
    else:
        total_emissions = None

    conn.close()
    return {
        'request': request_text,
        'results': results,
        'headers': headers,
        'total_emissions': total_emissions
    }

def findings_list():
    findings_list = []
    findings_list.append(get_findings(
        'SELECT * FROM country WHERE Coal > 95 ORDER BY Coal DESC;',
        'Countries powered mostly by Coal:'
    ))
    findings_list.append(get_findings(
        'SELECT * FROM country WHERE Gas == 100;',
        'Countries powered only by Gas:'
    ))
    findings_list.append(get_findings(
        'SELECT * FROM country WHERE Oil > 99 ORDER BY Oil DESC;',
        'Countries powered mostly by Oil:'
    ))
    findings_list.append(get_findings(
        'SELECT * FROM country WHERE Hydro == 100;',
        'Countries powered only by Hydro:'
    ))
    findings_list.append(get_findings(
        'SELECT * FROM country WHERE Renewable > 45 ORDER BY Renewable DESC;',
        'Countries consuming around the half of energy from Renewable sources:'
    ))
    findings_list.append(get_findings(
        'SELECT * FROM country WHERE Nuclear > 50 ORDER BY Nuclear DESC;',
        'Countries consuming more than the half of energy from Nuclear sources:'
    ))

    return findings_list

@app.route('/')
def home():
    findings = findings_list()
    for finding in findings:
        print(finding)
    return render_template('home.html', findings=findings)

@app.route('/sql-console')
def sql_console():
    conn = sqlite3.connect('data/CarbonFootprint.db')
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = [table[0] for table in cursor.fetchall()]
    return render_template('sql_console.html', tables=tables, history=query_history)

@app.route('/sql-console/execute', methods=['POST'])
def execute():
    query = request.form['query']
    headers, results, tables = None, None, None
    try:
        conn = sqlite3.connect('data/CarbonFootprint.db')
        cursor = conn.cursor()
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables = [table[0] for table in cursor.fetchall()]
        cursor.execute("SELECT name FROM sqlite_master WHERE type='view';")
        views = [view[0] for view in cursor.fetchall()]
        
        if is_select_query(query):
            cursor.execute(query)
            headers = [description[0] for description in cursor.description]
            results = cursor.fetchall()
            
            # Add the query to the start of the history list to show most recent first
            query_history.appendleft(query)
        else:
            results = [("Error:", "Only SELECT statements are allowed.")]
    except Exception as e:
        results = [("Error:", str(e))]
    finally:
        if conn:
            conn.close()
    return render_template('sql_console.html', headers=headers, results=results, history=list(query_history), tables=tables, views=views)

@app.route('/country-emissions', methods=['GET', 'POST'])
def country_emissions():
    selected_country = None
    data_rows = []
    total_emissions = 0
    annual_emissions = None
    electricity_consumption = None
    trees_balance = None

    # Connect to the database
    conn = sqlite3.connect('data/CarbonFootprint.db')
    cursor = conn.cursor()

    # Fetch all countries for the dropdown
    cursor.execute("SELECT Country FROM world UNION ALL SELECT '---' UNION ALL SELECT Country FROM country")
    all_countries = cursor.fetchall()

    if request.method == 'POST':
        # Get the selected country from the form
        selected_country = request.form.get('countrySelect')

        # Fetch data for the selected country
        cursor.execute("""
        SELECT "Source", UsagePercentage, MedianEmission, ROUND(Contribution, 2) AS Contribution 
        FROM CountryEmissionsView 
        WHERE Country = ?;
        """, (selected_country,))
        data_rows = cursor.fetchall()

        # Calculate the total emissions
        total_emissions = round(sum(row[3] for row in data_rows if row[3] is not None), 2)

        # Get the user-specified electricity consumption
        electricity_consumption = request.form.get('electricityConsumption')
        if electricity_consumption:
            try:
                annual_emissions = round(total_emissions * 365 * 24 * float(electricity_consumption) / 1000, 2)  # Convert to kg
                trees_balance = round(annual_emissions / 25, 2)
            except ValueError:
                electricity_consumption = None
                annual_emissions = None

    cursor.close()
    conn.close()

    return render_template('country_emissions.html', countries=all_countries, data=data_rows, selected_country=selected_country, total_emissions=total_emissions, annual_emissions=annual_emissions, electricity_consumption=electricity_consumption, trees_balance=trees_balance)

def is_select_query(query):
    return query.strip().lower().startswith('select')

if __name__ == '__main__':
    app.run(debug=True)
