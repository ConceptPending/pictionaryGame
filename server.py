from bottle import route, run, debug, template, static_file, post, request, app, get, redirect
from beaker.middleware import SessionMiddleware
import os
import psycopg2
import smtplib
import string
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import random
import cgi
import pusher

pusher.app_id = os.environ['pusher_app_id']
pusher.key = os.environ['pusher_key']
pusher.secret = os.environ['pusher_secret']

p = pusher.Pusher()

games = {}

@route('/')
def index():
    return template('template')

@route('/control')
def control_display():
    return template('control')

@post('/save')
def push_state():
    json = request.forms.get('json')
    p['test_channel'].trigger('my_event', json)
    return 1

####################
#  Define Session  #
####################
session_opts = {
    'session.type': 'memory',
    'session.url': 'localhost',
    'session.cookie_expires': (3600 * 24 * 31),
    'session.auto': True
}
app = SessionMiddleware(app(), session_opts)

################################
#  Define ancillary functions  #
################################
@route('/static/<filename>')
def serve_static(filename):
    return static_file(filename, root='static')

def send_email(fromaddr, toaddrs, subject, htmlmsg):
    # The actual mail send
    msg = MIMEMultipart('alternative')
    msg['Subject'] = subject
    msg['From'] = fromaddr
    msg['To'] = toaddrs
    part1 = MIMEText(htmlmsg, 'html')
    msg.attach(part1)
    server = smtplib.SMTP('smtp.gmail.com:587')  
    server.starttls()  
    server.login(os.environ['gmail_user'], os.environ['gmail_password'])  
    server.sendmail(fromaddr, toaddrs, msg.as_string())
    server.quit()

def authenticate():
    session = request.environ['beaker.session']
    return session

def logout():
    session = request.environ['beaker.session']
    session.delete()
    
def connect_db(host=os.environ['dbhost'], dbname=os.environ['dbname'], user=os.environ['dbuser'], password=os.environ['dbpassword'], sslmode='require'):
    conn_string = "host='%s' dbname='%s' user='%s' password='%s'" % (host, dbname, user, password)
    conn = psycopg2.connect(conn_string)
    conn.set_isolation_level(0)
    cur = conn.cursor()
    return cur

debug(False)
run(app=app, host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))
