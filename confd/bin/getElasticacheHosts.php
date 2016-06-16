#!/usr/local/bin/php
<?php

if( ! isset( $argv[1] ) ) {
  echo 'AWS Elasticache CFG Endpoint not passed as an argument' . PHP_EOL ;
  exit(1) ;
}

list( $url, $port ) = explode( ':', $argv[1] ) ;
if( empty( $url ) || ! is_string( $url ) ) {
  echo 'Invalid endpoint url : \''. $url .'\'' . PHP_EOL ;
  exit(1) ;
}

if( empty( $port ) || ! is_numeric( $port ) ) {
  echo 'Invalid endpoint port : \''. $port .'\'' . PHP_EOL ;
  exit(1) ;
}

$client = new Memcached();
$client->setOption( Memcached::OPT_CLIENT_MODE, Memcached::DYNAMIC_CLIENT_MODE ) ;
$client->addServer( $url, $port ) ;

if( count( $client->getServerList() ) > 0 ) {
  $output = null ;
  foreach( $client->getServerList() as $server )
    $output .= $server['host'] . ':' . $server['port'] . ',' ;
  echo trim( $output, ',' ) ;
  exit(0) ;
} else {
  echo 'No Elasticache servers found' . PHP_EOL ;
  exit(2) ;
}

?>
