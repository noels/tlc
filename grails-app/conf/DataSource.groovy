// Common dataSource settings
dataSource {

    // Default Grails stuff
    pooled = true
    driverClassName = 'org.hsqldb.jdbcDriver'
    username = 'sa'
    password = ''

    // The following sets up the Apache Commons DBCP database connection pooling to
    // avoid potential connection timeout problems when used in a long-running
    // environment (such a Production system which only gets re-booted as infrequently
    // as possible). The following are assumtions and therefore you should check them
    // out. In particular, ensure that the validationQuery is a valid SQL statement
    // for your database.
    properties {
        maxActive = 12                                  // Allow 16 active connections (remember to add in max task threads plus one - i.e. add 4 by default)
        maxIdle= 12                                     // Allow 16 threads to be idle at the same time
        minEvictableIdleTimeMillis = 1000 * 60 * 30     // Allow a connection to be idle for 30 minutes before being elegibile for eviction
        timeBetweenEvictionRunsMillis = 1000 * 60 * 30  // Run the eviction routine every 30 minutes
        numTestsPerEvictionRun = 3                      // Evict up to 3 idle connections in any eviction run
        testOnBorrow = true                             // Ensure the connection is alive before giving it to us (consider db server, firewall and O/S TCP/IP timeouts)
        testWhileIdle = false                           // Don't check connections when they're idle
        testOnReturn = false                            // Don't check a connection is alive when we give it back
        validationQuery = 'SELECT 1'                    // The SQL statement (must return at least one row) to use for testing - (Oracle would be "SELECT 1 FROM DUAL")
    }
}

// Hibernate caching settings
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = true
    cache.provider_class = 'net.sf.ehcache.hibernate.EhCacheProvider'
}

// Environment specific settings
environments {
    development {
        dataSource {
            dbCreate = 'update'     // one of 'create', 'create-drop','update'
            driverClassName = 'com.mysql.jdbc.Driver'
            url = 'jdbc:mysql://localhost:3306/tlc'
            username = 'developer'
            password = 'secret'
        }
    }
    test {
        dataSource {
            dbCreate = 'update'
            url = 'jdbc:hsqldb:mem:testDb'
        }
    }
    production {
        dataSource {
            dbCreate = 'update'
            driverClassName = 'com.mysql.jdbc.Driver'
            url = 'jdbc:mysql://localhost:3306/tlc'
            username = 'enduser'
            password = 'secret'
        }
    }
}