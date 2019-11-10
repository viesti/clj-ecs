(ns clj-ecs.core
  (:require [ring.adapter.jetty :as jetty]
            [timbre-json-appender.core :as tas]
            [taoensso.timbre :as timbre]))

(defn handler [{:keys [uri]}]
  (timbre/info :uri uri)
  {:status  200
   :headers {"Content-Type" "text/plain"}
   :body    "Hello World!"})

(defn -main [& _]
  (tas/install)
  (jetty/run-jetty handler
                   {:port (or (some-> (System/getenv "PORT")
                                      (Integer/parseInt))
                              4000)}))
