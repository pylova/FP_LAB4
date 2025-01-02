# FP_LAB4
<p align="center"><b>Національний технічний університет України “Київський політехнічний інститут ім. Ігоря Сікорського”</b></p>
<p align="center"><b>Факультет прикладної математики Кафедра системного програмування і спеціалізованих комп’ютерних систем</b></p>
<p align="center"><b>ЛАБОРАТОРНА РОБОТА №4</b></p>
<p align="center"><b>з дисципліни «Вступ до функціонального програмування»</b></p>

<div align="right">
    <p>Студентка: Пильова Д.М</p>
    <p>Група: КВ-11</p>
    <p>Рік: 2024</p>
</div>

## Загальне завдання

Реалізуйте алгоритм сортування чисел у списку двома способами: функціонально і імперативно. 
1. Переписати функціональну реалізацію алгоритму сортування з лабораторної роботи 3 з такими змінами:
	- використати функції вищого порядку для роботи з послідовностями (де це доречно);
	- додати до інтерфейсу функції (та використання в реалізації) два ключових параметра: key та test , що працюють аналогічно до того, як працюють параметри з такими назвами в функціях, що працюють з послідовностями. При цьому key має виконатись мінімальну кількість разів
2. Реалізувати функцію, що створює замикання, яке працює згідно із завданням за варіантом (див. п 4.1.2). Використання псевдо-функцій не забороняється, але, за можливості, має бути мінімізоване.

Алгоритм сортування вибором за незменшенням.

```lisp
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


```
## Завдання за варіантом №8
2. Написати функцію remove-each-rnth-reducer , яка має один основний параметр n та
один ключовий параметр — функцію key . remove-each-rnth-reducer має повернути
функцію, яка при застосуванні в якості першого аргумента reduce робить наступне: при
обході списку з кінця, кожен n -ний елемент списку-аргумента reduce , для якого
функція key повертає значення t (або не nil ), видаляється зі списку. Якщо
користувач не передав функцію key у remove-each-rnth-reducer , тоді зі списку
видаляється просто кожен n -ний елемент. Обмеження, які накладаються на
використання функції-результату remove-each-rnth-reducer при передачі у reduce
визначаються розробником (тобто, наприклад, необхідно чітко визначити, якими мають
бути значення ключових параметрів функції reduce from-end та initial-value ).

```lisp
(defun remove-each-rnth-reducer (n &optional (key nil))
  (let ((counter 0))
    (lambda (elem acc)
      (incf counter)
      (if (or (and key (funcall key elem))  
              (and (not key) (zerop (mod counter n)))) 
          acc
          (cons elem acc)))))

```

3. Тести

```lisp
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

(defun check-remove-each-rnth-reducer (name input n expected &key initial-value from-end key)
  (let ((result (reduce (remove-each-rnth-reducer n key) input 
                        :from-end from-end 
                        :initial-value initial-value)))
    (format t "~:[FAILED~;PASSED~]... ~a~%" 
            (equal result expected)
            name)
    (when (not (equal result expected))
      (format t "Expected: ~a~%Got: ~a~%~%" expected result))))

(defun test-remove-each-rnth-reducer ()
  "Тестує функцію remove-each-rnth-reducer на різних випадках."
  
  ;; Тести за замовчуванням
  (check-remove-each-rnth-reducer "Test 1" '(1 2 3 4) 2 '(2 4) :from-end t :initial-value '())
  (check-remove-each-rnth-reducer "Test 2" '(1 2 3 4 5 6) 3 '(2 3 5 6) :from-end t :initial-value '())
  (check-remove-each-rnth-reducer "Test 3" '(1 2 3 4 5) 1 '() :from-end t :initial-value '())
  
  ;; Тест для порожнього списку
  (check-remove-each-rnth-reducer "Test 4" '() 2 '() :from-end t :initial-value '())

  ;; Тести з використанням ключового параметру
  (check-remove-each-rnth-reducer "Test 5" '(1 2 3 4) 2 '(1 3) :from-end t :initial-value '() :key #'evenp)
  (check-remove-each-rnth-reducer "Test 6" '(1 2 3 4 5 6) 2 '(2 4 6) :from-end t :initial-value '() :key #'oddp)
  
  ;; Додаткові тести
  (check-remove-each-rnth-reducer "Test 7" '(10 20 30 40 50) 2 '(10 30 50) :from-end t :initial-value '())
  (check-remove-each-rnth-reducer "Test 8" '(10 20 30 40 50) 3 '(10 20 40 50) :from-end t :initial-value '())
  (check-remove-each-rnth-reducer "Test 9" '(1 1 1 1 1) 2 '(1 1 1) :from-end t :initial-value '())
  (check-remove-each-rnth-reducer "Test 10" '(5 6 7 8 9) 1 '(6 8) :from-end t :initial-value '() :key #'oddp))

```

## Результат виконання програми

```
PASSED... Test 1
PASSED... Test 2
PASSED... Test 3
PASSED... Test 4
PASSED... Test 5
PASSED... Test 6
PASSED... Test 7
PASSED... Test 8
PASSED... Test 9
PASSED... Test 10
T
```
