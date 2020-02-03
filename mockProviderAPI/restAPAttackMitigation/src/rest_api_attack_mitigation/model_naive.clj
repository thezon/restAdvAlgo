(ns rest-api-attack-mitigation.model-naive
  (:require [clojure.string :as str]
            [ring.util.response :as ru]
            [incanter.stats :as stat]))

;The number of previous calls to evaluate 
(def param-values (atom []))

(defn eval-param-values [v]
  (do (swap! param-values conj v)
    (/ (- (stat/mean @param-values) v) (stat/sd @param-values))))

(defn log-model[results & others]
   (spit "model-log.txt" (str "isec determination: " results " inputs: " others "\n") :append true))

(defn stub-model [path param]
   (let [safe? (if (not= path "mockEndpoint")
                 false
                 (try (let[param-value (Integer. param)
                           dist (Math/abs (eval-param-values param-value))
                           _ (log-model dist @param-values  )]
                        (if (> dist 1)
                          false
                          true))        
                   (catch Exception e false)))
         _ (log-model safe? path param )]
     safe?))


(defn stub-preprocess-model-input [request]
  (if (= (:uri request) "/favicon.ico")
    ["fail" -1]
    (try
      (let [parsed-uri (rest (str/split (:uri request) #"/"))]
        (if (= (count parsed-uri) 2)
          parsed-uri
          ["fail",-1]))
      (catch Exception e ["fail",-1]))))

(defn model-factory [preprocess model]
  (fn [request]
    (apply model 
           (preprocess request))))

; decouples model changes from request flows
(def isec-model (model-factory stub-preprocess-model-input stub-model))

  
(defn wrap-intelligent-security [handler]
  (fn [request]
    (let [response (handler request) ; called on every request
          _ (spit "rawRequest.txt" (str request "\n")  :append true)
          safe? (isec-model request)]
      (if safe?
        (handler request)
        (ru/status request 401)))))


