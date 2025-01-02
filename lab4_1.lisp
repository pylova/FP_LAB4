(defun insert-with-key-and-test (value sorted key test)
  (let ((value-key (funcall key value)))
    (if (null sorted)
        (list value)
        (let ((first-key (funcall key (car sorted))))
          (if (funcall test value-key first-key)
              (cons value sorted)
              (cons (car sorted)
                    (insert-with-key-and-test value (cdr sorted) key test)))))))

(defun sort-insertion-functional (unsorted &key (key #'identity) (test #'<))
  (reduce (lambda (sorted value)
            (insert-with-key-and-test value sorted key test))
          unsorted
          :initial-value nil))

(defun test-insert-with-key-and-test ()
  (let ((key #'identity) ;; Простий ключ: повертає сам елемент
        (test #'>))      ;; Тест: сортування за спаданням
    (let ((result (insert-with-key-and-test 5 '(10 8 3) key test))) ;; Вставляємо 5 у список
      (if (equalp result '(10 8 5 3))
          (format t "Test insert-with-key-and-test: PASSED~%")
          (format t "Test insert-with-key-and-test: FAILED. Expected: ~A, Got: ~A~%"
                  '(10 8 5 3) result)))))

(defun test-sort-insertion-functional ()
  (let ((key #'identity) ;; Простий ключ: повертає сам елемент
        (test #'<))      ;; Тест: сортування за зростанням
    (let ((result (sort-insertion-functional '(4 1 3 5 2) :key key :test test)))
      (if (equalp result '(1 2 3 4 5))
          (format t "Test sort-insertion-functional: PASSED~%")
          (format t "Test sort-insertion-functional: FAILED. Expected: ~A, Got: ~A~%"
                  '(1 2 3 4 5) result)))))
(defun run-tests ()
  (format t "Running tests...~%")
  (test-insert-with-key-and-test)
  (test-sort-insertion-functional))

(run-tests)
