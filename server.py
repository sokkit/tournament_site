from flask import Flask, render_template, request, redirect
import mysql.connector
import sys
import root_password as rp

app = Flask(__name__)
db = mysql.connector.connect(host="localhost", user="root", password=rp.get_password(), database="tourn")

@app.route('/Home')
def home():
    return render_template('home.html')

@app.route('/Tournament', methods = ['GET'])
def tournament():
    if request.method == 'GET':
        print("fetching data", file=sys.stdout)
        try:
            cur = db.cursor()
            cur.callproc('getStandings', [1])
            iterator = cur.stored_results()
            for result in iterator:
                standings = result.fetchall()
        except Exception as e:
            print("There was an error: ", e)
        return render_template('tournament.html', standings = standings)


if __name__ == "__main__":
    app.run(debug=True)
