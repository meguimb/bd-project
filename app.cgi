#!/usr/bin/python3

from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template, request, redirect, url_for

## Libs postgres
import psycopg2
import psycopg2.extras

app = Flask(__name__)

## SGBD configs
DB_HOST="db.tecnico.ulisboa.pt"
DB_USER="ist199272" 
DB_DATABASE=DB_USER
DB_PASSWORD="cats"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)


## Runs the function once the root page is requested.
## The request comes with the folder structure setting ~/web as the root
@app.route('/')
def index():
  try:
    return render_template("index.html", params=request.args)
  except Exception as e:
    return str(e)

@app.route('/menu')
def menu_principal():
  try:
    return render_template("index.html", params=request.args)
  except Exception as e:
    return str(e)

@app.route('/retalhista')
def listar_retalhistas():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT * FROM retalhista"
    cursor.execute(query)
    return render_template("retalhista.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e) 
  finally:
    cursor.close()
    dbConn.close()

@app.route('/retalhista/inserir')
def inserir_retalhista():
  try:
    return render_template("inserir_retalhista.html", params=request.args)
  except Exception as e:
    return str(e)

@app.route('/retalhista/remover')
def remover_retalhista():
  try:
    return render_template("remover_retalhista.html", params=request.args)
  except Exception as e:
    return str(e)

@app.route('/retalhista/perform_delete', methods=["POST"])
def remover_retalhista_daDB():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "DELETE FROM responsavel_por WHERE tin=%s \
      DELETE FROM evento_reposicao WHERE tin=%s \
      DELETE FROM retalhista WHERE nome=%s AND tin=%s;"
    data = (request.form["tin"], request.form["tin"], request.form["nome"], request.form["tin"],)
    cursor.execute(query,data)
    return render_template("retalhista.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e) 
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()

@app.route('/retalhista/executar_inserir', methods=["POST"])
def executar_inserir_retalhista():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "INSERT INTO retalhista VALUES (%s,%s);"
    data = (request.form["tin"],request.form["nome"],)
    cursor.execute(query,data)
    return render_template("retalhista.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e)
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()

CGIHandler().run(app)
