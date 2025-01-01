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
  (let ((value-key (funcall key value))) ;; Обчислюємо ключове значення для елемента
    (if (null sorted)
        (list value) ;; Якщо список порожній, створюємо новий список
        (let ((first-key (funcall key (car sorted)))) ;; Обчислюємо ключове значення першого елемента
          (if (funcall test value-key first-key)
              (cons value sorted) ;; Вставляємо перед першим елементом
              (cons (car sorted)
                    (insert-with-key-and-test value (cdr sorted) key test))))))) ;; Рекурсивний виклик для решти списку

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

(defun remove-each-rnth-reducer (n &key (key #'identity))
  (lambda (acc elem) ;; lambda
    (let ((current-index (length acc))) ;; index
      (if (and (= (mod (+ current-index 1) n) 0) ;; nth
               (funcall key elem)) ;; condition
          acc ;; skip
          (cons elem acc))))) ;; add

(defun test-remove-each-rnth-reducer (list n &key (key #'identity))
  "Тестова функція для застосування remove-each-rnth-reducer."
  (reduce (remove-each-rnth-reducer n :key key) ;; reducer
          list
          :from-end t ;; reverse
          :initial-value nil)) ;; init
;; Функція для тестування remove-each-rnth-reducer
(defun test-remove-each-rnth-reducer (test-number n input expected &optional key)
  "Тестує remove-each-rnth-reducer на заданому списку."
  (let ((result (reduce (remove-each-rnth-reducer n :key key) ;; Використовуємо нашу функцію
                        input
                        :from-end t ;; Проходимо список з кінця
                        :initial-value nil))) ;; Початкове значення
    ;; Порівнюємо отриманий результат із очікуваним
    (if (equalp result expected)
        (format t "Test ~A: PASSED~%" test-number) ;; Якщо збігається
        (format t "Test ~A: FAILED~%   Expected: ~A~%   Got: ~A~%" ;; Якщо не збігається
                test-number expected result))))

;; Приклади тестів
(format t "Testing remove-each-rnth-reducer~%")
(test-remove-each-rnth-reducer 1 3 '(1 2 3 4 5 6 7 8 9) ;; Кожен 3-й елемент
                               '(1 2 4 5 7 8)) ;; Очікуваний результат
(test-remove-each-rnth-reducer 2 2 '(1 2 3 4 5 6 7 8 9) ;; Кожен 2-й
                               '(1 3 5 7 9))
(test-remove-each-rnth-reducer 3 4 '(10 20 30 40 50 60) ;; Кожен 4-й
                               '(10 20 30 50 60))
(test-remove-each-rnth-reducer 4 2 '(1 2 3 4 5 6) ;; З key
                               '(1 3 5)
                               (lambda (x) (evenp x))) ;; Видаляємо парні


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

;; Тестова функція для sort-insertion-functional
(defun test-sort-insertion-functional ()
  (let ((key #'identity) ;; Простий ключ: повертає сам елемент
        (test #'<))      ;; Тест: сортування за зростанням
    (let ((result (sort-insertion-functional '(4 1 3 5 2) :key key :test test)))
      (if (equalp result '(1 2 3 4 5))
          (format t "Test sort-insertion-functional: PASSED~%")
          (format t "Test sort-insertion-functional: FAILED. Expected: ~A, Got: ~A~%"
                  '(1 2 3 4 5) result)))))

;; Виконання тестів
(test-insert-with-key-and-test)
(test-sort-insertion-functional)

```

## Результат виконання програми

```

```
