###
# Turn on everything I need to start my day
###

# Paths [change these]
tomcat=~/dev/Tomcat
activemq=~/dev/ActiveMQ
mongo=~/dev/MongoDB
dev=~/dev

# Shutdown anything already running
echo -e "\n\n=== Shutting Down Tomcat ===\n\n"
$tomcat/bin/shutdown.sh
echo -e "\n\n=== Shutting Down Apache ActiveMQ ===\n\n"
$activemq/bin/activemq stop
echo -e "\n\n=== Shutting Down MySQL ===\n\n"
mysqladmin -u root shutdown
echo -e "\n\n=== Removing MongoDB Lock File ===\n\n"
rm -f /data/db/mongod.lock
# TODO: Should shutdown mongo if it's already running

# Start everything
sudo echo -e "\n\n=== Starting MySQL ===\n\n"
sudo mysqld_safe5 > /dev/null 2>&1 &

echo -e "\n\n=== Starting MongoDB ===\n\n"
mkdir $mongo/logs
$mongo/bin/mongod --fork --logpath $mongo/logs/mongo.out
echo -e "\n\n=== Rebuilding Project ===\n\n"
$dev/setup.sh 13
echo -e "\n\n=== Starting Apache ActiveMQ ===\n\n"
$activemq/bin/activemq start
echo -e "\n\n=== Starting Tomcat ===\n\n"
$tomcat/bin/startup.sh

# Tail tomcat
echo -e "\n\n=== Tailing Tomcat ===\n\n"
tail -f $tomcat/logs/catalina.out