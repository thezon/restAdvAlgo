(defproject rest-api-attack-mitigation "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  
  
  :plugins [[lein-ring "0.12.2"]]
  :ring {:handler rest-api-attack-mitigation.core/app-handler }
  
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [compojure "1.6.0"]
                 [liberator "0.15.1"] 
                 [ring/ring-core "1.6.3"]
                 [ring-logger "1.0.1"]
                 [ring/ring-jetty-adapter "1.6.3"]
                 [incanter "1.9.3"]]) 
