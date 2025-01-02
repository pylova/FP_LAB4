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
(defun remove-each-rnth-reducer (n &key (key #'identity))
  "Returns a reducer function to remove every nth element based on the key."
  (let ((index 0)) ;; Initialize the index
    (lambda (acc elem)
      (let ((current-index (incf index))) ;; Increment index on each call
        (if (and (= (mod current-index n) 0)
                 (funcall key elem)) ;; Check the condition to skip
            acc ;; Skip adding this element
            (cons elem acc))))))


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

(defun test-remove-each-rnth-reducer (test-number n input expected &optional key)
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
(test-remove-each-rnth-reducer 1 3 '(1 2 3 4 5 6 7 8 9) '(1 2 4 5 7 8)) ;; Кожен 3-й елемент
(test-remove-each-rnth-reducer 2 2 '(1 2 3 4 5 6 7 8 9) '(1 3 5 7 9)) ;; Кожен 2-й
(test-remove-each-rnth-reducer 3 4 '(10 20 30 40 50 60) '(10 20 30 50 60)) ;; Кожен 4-й
(test-remove-each-rnth-reducer 4 2 '(1 2 3 4 5 6) '(1 3 5) (lambda (x) (evenp x))) ;; Видаляємо парні
```

## Результат виконання програми

```

```
