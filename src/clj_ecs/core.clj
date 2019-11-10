(ns clj-ecs.core
  (:require [ring.adapter.jetty :as jetty]))

(defn handler [_]
  (println "Awesome")
  {:status  200
   :headers {"Content-Type" "text/plain"}
   :body    "Hello World!"})

(defn -main [& _]
  (jetty/run-jetty handler
                   {:port (or (some-> (System/getenv "PORT")
                                      (Integer/parseInt))
                              4000)}))
