#!/sbin/runscript

depend() {
	use net logger
	after postgresql
}


start() {
	[ -n "${SERVER_CONF}" ] \
		&& SERVER_OPTS="${SERVER_OPTS} --config=${SERVER_CONF}" \
		|| SERVER_OPTS="${SERVER_OPTS} --config=/etc/tinyerp/terp_serverrc"
	[ -n "${SERVER_DB}" ] && SERVER_OPTS="${SERVER_OPTS} --database=${SERVER_DB}"
	[ -n "${SERVER_USER}" ] && SERVER_OPTS="${SERVER_OPTS} --db_user=${SERVER_USER}"
	[ -n "${SERVER_PW}" ] && SERVER_OPTS="${SERVER_OPTS} --db_password=${SERVER_PW}"
	[ -n "${SERVER_HOST}" ] && SERVER_OPTS="${SERVER_OPTS} --db_host=${SERVER_HOST}"
	[ -n "${SERVER_PORT}" ] && SERVER_OPTS="${SERVER_OPTS} --db_port=${SERVER_PORT}"
								
	ebegin "Starting TinyERP"
	start-stop-daemon --start --quiet --background --user terp:terp --pidfile=/var/run/tinyerp/tinyerp.pid --startas /usr/bin/tinyerp-server -- ${SERVER_OPTS}
	eend $?
}


stop() {
	ebegin "Stopping TinyERP"
	start-stop-daemon --stop --quiet --pidfile=/var/run/tinyerp/tinyerp.pid
	eend $?
}

