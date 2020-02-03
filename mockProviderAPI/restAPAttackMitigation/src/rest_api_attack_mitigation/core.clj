(ns rest-api-attack-mitigation.core
  (:require [liberator.core :refer [resource defresource ]]
              [ring.middleware.params :refer [wrap-params]]
              [compojure.core :refer [defroutes ANY]]
              [ring.logger :as logger]
              [ring.adapter.jetty :as jetty]
              [rest-api-attack-mitigation.model-naive :as isec]))


(defresource mockEndpoint [text]
  :available-media-types ["text/plain"]
  :handle-ok (fn [_] (format "The text from agent is %s" text)))


(defroutes app
  (ANY "/mockEndpoint/:text" [text] (mockEndpoint text))
  (ANY "/foo" [] (resource :available-media-types ["text/html"]
                         :handle-ok "<html>Hello, Internet.</html>")))




(def app-handler 
  (-> app wrap-params isec/wrap-intelligent-security ))

; run from lien ring server 4444
; plugin sets the handler app-hanlder




;(jetty/run-jetty (logger/wrap-with-logger app) {:port 4444})
; use lein: ring server 4444

 