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

def random_string(length=6):
    pool = string.letters + string.digits
    return ''.join(random.choice(pool) for i in xrange(length))

games = {}
words =['tomato','kitten','octopus',"horse","horse","trip","round","park","state","baseball","dominoes","hockey","whisk","mattress","circus","cowboy","skate","thief","spring","toast","roller","half","door"]

@route('/')
def index():
    id = random_string()
    return template('template', id=id)

@route('/control/<id>')
def control_display(id):
    random.shuffle(words)
    word = words[0]
    p['pict_%s' % id].trigger('start_event', "begin")
    return template('control', word=word, id=id)

@post('/save/<id>')
def push_state(id):
    json = request.forms.get('json')
    p['pict_%s' % id].trigger('my_event', json)
    return {'success' : 'yes'}


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
