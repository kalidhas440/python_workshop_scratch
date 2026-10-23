list1 = [x*x for x in range(11,)]
list2 = [y for y in range(11)]

for x,y in zip(list1, list2):
    print(x, y, end=' ')

def add(a, b):
    x = a + b
    return x

fruits = ["mango", "banana", "jackfruit"]

for index, x in enumerate(fruits):
    print(index, end=' ')
    print(x)

print(25**2)
