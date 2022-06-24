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
    query = "DELETE FROM responsavel_por WHERE tin=%s; \
      DELETE FROM evento_reposicao WHERE tin=%s; \
      DELETE FROM retalhista WHERE tin=%s;"
    data = (request.form["tin"], request.form["tin"], request.form["tin"],)
    cursor.execute(query,data)
    return redirect(url_for('listar_retalhistas'))
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
    return redirect(url_for('listar_retalhistas'))
  except Exception as e:
    return str(e)
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()

@app.route('/categoria')
def listar_categorias():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT * FROM categoria"
    cursor.execute(query)
    return render_template("categoria.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e) 
  finally:
    cursor.close()
    dbConn.close()

@app.route('/categoria/inserir')
def inserir_categoria():
  try:
    return render_template("inserir_categoria.html", params=request.args)
  except Exception as e:
    return str(e)

@app.route('/categoria/executar_inserir', methods=["POST"])
def executar_inserir_categoria():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "INSERT INTO categoria VALUES (%s);"
    data = (request.form["nome"],)
    cursor.execute(query,data)
    return redirect(url_for('listar_categorias'))
  except Exception as e:
    return str(e)
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()

@app.route('/categoria/inserir_subcategoria')
def inserir_subcategoria():
  try:
    return render_template("inserir_subcategoria.html", params=request.args)
  except Exception as e:
    return str(e)

@app.route('/categoria/executar_inserir_subcategoria', methods=["POST"])
def executar_inserir_subcategoria():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "INSERT INTO categoria VALUES (%s); \
      INSERT INTO categoria_simples VALUES (%s); \
      DELETE FROM categoria_simples WHERE nome = %s; \
      INSERT INTO super_categoria VALUES (%s) ON CONFLICT DO NOTHING; \
      INSERT INTO tem_outra VALUES (%s, %s);"
    data = (request.form["nomesub"], request.form["nomesub"], request.form["nome"], 
    request.form["nome"], request.form["nome"], request.form["nomesub"],)
    cursor.execute(query,data)
    return redirect(url_for('listar_categorias'))
  except Exception as e:
    return str(e)
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()

@app.route('/categoria/remover')
def remover_categoria():
  try:
    return render_template("remover_categoria.html", params=request.args)
  except Exception as e:
    return str(e)

@app.route('/categoria/perform_delete', methods=["POST"])
def remover_categoria_daDB():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "DELETE FROM responsavel_por WHERE nome_cat=%s; \
      DELETE FROM evento_reposicao WHERE ean IN (SELECT ean FROM produto WHERE cat=%s); \
      DELETE FROM planograma WHERE nro IN (SELECT nro FROM prateleira WHERE nome=%s); \
      DELETE FROM prateleira WHERE nome=%s; \
      DELETE FROM tem_categoria WHERE categoria=%s; \
      DELETE FROM produto WHERE cat=%s; \
      DELETE FROM tem_outra WHERE categoria=%s; \
      DELETE FROM tem_outra WHERE super_categoria=%s; \
      DELETE FROM super_categoria WHERE nome=%s; \
      DELETE FROM categoria_simples WHERE nome=%s; \
      DELETE FROM categoria WHERE nome=%s;"
    data = (request.form["nome"], request.form["nome"], request.form["nome"],
    request.form["nome"], request.form["nome"], request.form["nome"], request.form["nome"],
    request.form["nome"], request.form["nome"], request.form["nome"], request.form["nome"],)
    cursor.execute(query,data)
    return redirect(url_for('listar_categorias'))
  except Exception as e:
    return str(e) 
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()

@app.route('/categoria/listar_subcategorias')
def listar_subcategorias():
  try:
    return render_template("listar_subcategorias.html", params=request.args)
  except Exception as e:
    return str(e)

@app.route('/categoria/executar_listar_subcategorias', methods=["POST"])
def executar_listar_subcategorias():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "WITH RECURSIVE subcategoria AS (SELECT categoria AS sub FROM tem_outra WHERE super_categoria=%s \
              UNION ALL \
              SELECT categoria FROM subcategoria, tem_outra \
              WHERE subcategoria.sub = tem_outra.super_categoria) \
              SELECT * FROM subcategoria;"
    data = (request.form["nome"],) 
    cursor.execute(query,data)
    return render_template("executar_listar_subcategorias.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e)
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()

@app.route('/IVM')
def listar_IVMs():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT * FROM IVM"
    cursor.execute(query)
    return render_template("IVM.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e) 
  finally:
    cursor.close()
    dbConn.close()

@app.route('/IVM/listar_eventos')
def listar_eventos():
  try:
    return render_template("listar_eventos.html", params=request.args)
  except Exception as e:
    return str(e)

@app.route('/IVM/executar_listar_eventos', methods=["POST"])
def executar_listar_eventos():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    cursor2 = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT r.num_serie, r.fabricante, r.nro, r.ean, r.instante, r.unidades \
      FROM evento_reposicao AS r \
      WHERE r.num_serie = %s;"
    query2 = "SELECT p.nome, r.unidades \
      FROM evento_reposicao AS r INNER JOIN prateleira AS p \
      ON (r.nro = p.nro) AND (r.num_serie = p.num_serie) AND (r.fabricante = p.fabricante) \
      WHERE r.num_serie = %s \
      GROUP BY p.nome, r.unidades;"
    data = (request.form["num_serie"],)
    cursor.execute(query,data)
    cursor2.execute(query2,data)
    return render_template("IVM_eventos.html", cursor1=cursor, cursor2=cursor2, params=request.args)
  except Exception as e:
    return str(e)
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()

CGIHandler().run(app)
