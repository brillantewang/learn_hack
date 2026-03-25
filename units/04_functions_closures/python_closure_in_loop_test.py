def make_adders():
	adders = []
	for i in range(1, 4):
		adders.append(lambda x: x + i)
	return adders

adders = make_adders()
print(adders[0](10), adders[1](10), adders[2](10)) # should be "13 13 13" because of closure in a loop bug
