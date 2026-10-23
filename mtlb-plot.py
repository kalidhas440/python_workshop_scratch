import matplotlib.pyplot as plt

x = [i for i in range(-2000, 2000)]
y = [i * i for i in x]

plt.plot(x, y)

# plt.bar(x, y, width=0.99)

plt.title("Line Graph of y = x²")
plt.xlabel("X values")
plt.ylabel("Y values")
plt.grid(True)

plt.show()
