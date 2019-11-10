(ns clj-ecs.core
  (:require [ring.adapter.jetty :as jetty]
            [timbre-json-appender.core :as tas]
            [taoensso.timbre :as timbre]))

(defn handler [git-sha {:keys [uri]}]
  (timbre/info :uri uri :git-sha git-sha)
  {:status  200
   :headers {"Content-Type" "text/plain"}
   :body    (str "Hello World!"
                 (when git-sha
                   (str " Running at " git-sha)))})

(defn -main [& _]
  (tas/install)
  (jetty/run-jetty (partial handler (System/getenv "GIT_SHA"))
                   {:port (or (some-> (System/getenv "PORT")
                                      (Integer/parseInt))
                              4000)}))
