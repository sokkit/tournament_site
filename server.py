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
            # IDEA: GET TOURNAMENT NAME
            cur = db.cursor()
            # Get standings data
            cur.callproc('getStandings', [1])
            iterator = cur.stored_results()
            for result in iterator:
                standings = result.fetchall()
            # Get match data
            cur.callproc('getMatches', [1])
            iterator = cur.stored_results()
            for result in iterator:
                matches = result.fetchall()
        except Exception as e:
            print("There was an error: ", e)
        return render_template('tournament.html', standings = standings, matches = matches)


if __name__ == "__main__":
    app.run(debug=True)
