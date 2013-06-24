(in-package :epmd-server)

(defclass node-registry ()
  ((table :reader table :initform (make-hash-table))))

(defun make-node-registry ()
  (make-instance 'node-registry))

(defclass node ()
  ((name            :initarg :name)
   (port            :initarg :port)
   (type            :initarg :node-type       :initform :erlang)
   (protocol        :initarg :protocol        :initform :tcpip4)
   (lowest-version  :initarg :lowest-version  :initform 5)
   (highest-version :initarg :highest-version :initform 5)
   (extra           :initarg :extra           :initform ""))
  (:documentation "A registered node."))


(defgeneric find-node (registry node-name)
  (:documentation "Return the node associated with node-name in registry."))

(defmethod find-node ((registry node-registry) (node-name string))
  (with-slots (table) registry
    (gethash node-name table)))


(defgeneric register-node (registry node-name node)
  (:documentation "Store node info in the registry."))

(defmethod register-node ((registry node-registry) (node-name string) node)
  (with-slots (table) registry
    (setf (gethash node-name table) node)))


(defgeneric unregister-node (registry node-name)
  (:documentation "Unregister the node associated with node-name."))

(defmethod unregister-node ((registry node-registry) (node-name string))
  (with-slots (table) registry
    (remhash node-name table)))


(defgeneric get-all-nodes (registry)
  (:documentation "Return a list of all registered nodes."))

(defmethod get-all-nodes ((registry node-registry))
  (loop for node being the hash-values in (table registry) collect node))
