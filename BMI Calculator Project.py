#!/usr/bin/env python
# coding: utf-8

# # BMI Calculator

# In[16]:


name = input("Enter your name: ")

weight = int(input("Enter your weight in pounds: "))

height = int(input("Enter your height in inches: "))

BMI = (weight * 703) / (height * height)

print(BMI)

if BMI>0:
    if(BMI<18.5):
        print(name + ", you are underweight.")
    elif (BMI<=24.9):
        print(name + ", you are normal weight.")
    elif (BMI<29.9):
        print(name + ", you are overweight. You need to exercise more.")
    elif (BMI<34.9):
        print(name + ", you are obese.")
    elif (BMI<99.9):
        print(name + ", you are severely obese.")
    else: 
        print(name + ", you are morbidly obese.")
else:
    print("Enter valid input.")


# In[4]:


print(weight)


# In[7]:


type(height)


# In[14]:


if BMI>0:
    if(BMI<18.5):
        print(name + ", you are underweight.")
    elif (BMI<=24.9):
        print(name + ", you are normal weight.")
    elif (BMI<29.9):
        print(name + ", you are overweight.")
    elif (BMI<34.9):
        print(name + ", you are obese.")
    elif (BMI<99.9):
        print(name + ", you are severely obese.")
    else: 
        print(name + ", you are morbidly obese.")
else:
    print("Enter valid input.")


# In[ ]:


# BMI = (weight in pounds x 703) / (height in inches x height in inches)


# In[ ]:


print(weight)

