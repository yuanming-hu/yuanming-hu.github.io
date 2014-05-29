window.NAN.maximumNumber = 1000000000

class NAN.NumberSet
	constructor: ()->
		@numbers = []
		@description = "Interesting Number"

	analyze: (n)->
		n = parseInt(n)
		if n in @numbers
			return {score: Math.max(1, n) / Math.max(1, @numbers.indexOf(n)), description: @description}
		return null

class NAN.PrimeNumberSet extends NAN.NumberSet
	isPrime: (n)->
		n = parseInt(n)
		if n == 2
			return true
		if n < 2
			return false
		a = 2
		while a * a <= n
			if n % a == 0
				return false
			a += 1
		return true

	constructor: ()->
		@description = "质数"

	analyze: (n)->
		n = parseInt(n)
		if @isPrime(n)
			result = {}
			result.score = Math.floor(10 + Math.pow(Math.log(n), 2.5))
			result.description = @description
			return result
		return null

class NAN.PureOddNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "纯奇数"

	analyze: (n)->
		for char in n
			if parseInt(char) % 2 == 0
				return null 
		result = {score: Math.max(0, n.length - 4), description: @description}
		return result

class NAN.PureEvenNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "纯偶数"

	analyze: (n)->
		for char in n
			if parseInt(char) % 2 == 1
				return null 
		result = {score: Math.max(0, n.length - 4), description: @description}
		return result


class NAN.PureNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "纯数"

	analyze: (n)->
		for char in n
			if char != n[0]
				return null
		result = {score: 10 * Math.pow(Math.max(0, n.length - 2), 2), description: @description}
		return result


class NAN.APNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "等差数列数"

	analyze: (n)->
		return null if n.length < 3 
		delta = -1
		for i in [0...n.length - 1]
			newDelta = (n[i + 1] - n[i] + 10) % 10
			if newDelta == 0
				return null
			if delta == -1
				delta = newDelta
			else 
				if delta != newDelta
					return null
		result = {score: n.length, description: @description}
		return result


class NAN.WaveNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "波浪数"

	analyze: (n)->
		return null if n.length < 3 
		lastDelta = 0
		for i in [0...n.length - 1]
			newDelta = (n[i + 1] - n[i])
			return null if Math.abs(newDelta) != 1
			if lastDelta != 0 and newDelta + lastDelta != 0
				return null
			lastDelta = newDelta
		result = {score: n.length, description: @description}
		return result


class NAN.PowerOf2NumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "2的幂"
		a = 1
		while a < NAN.maximumNumber
			@numbers.push(a)
			a *= 2

class NAN.CloseToSomePowerOf2NumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "接近2的幂"
		a = 16
		while a < NAN.maximumNumber
			@numbers.push(a + 1)
			@numbers.push(a - 1)
			a *= 2

class NAN.SquareNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "平方数"
		for a in [0...Math.floor(Math.sqrt(NAN.maximumNumber))]
			@numbers.push(a * a)

class NAN.CubicNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "立方数"
		for a in [0...NAN.maximumNumber]
			@numbers.push(a * a * a) 
			break if a * a * a >= NAN.maximumNumber 


class NAN.FactorialNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "阶乘数"
		a = 1
		for i in [1..1000]
			a = a * i
			break if a >= NAN.maximumNumber 
			@numbers.push(a)

class NAN.HundredNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "以0结尾"
		a = 1
		for i in [1..1000]
			a = a * 10
			for b in [1..9]
				break if a * b >= NAN.maximumNumber 
				@numbers.push(a * b)

	analyze: (n)->
		result = super(n)
		if result
			result.score = Math.sqrt(result.score)
		return result

class NAN.AutomorphicNumberNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "Automorphic Number"
		###
		a = 0
		b = 1
		for i in [1..1000]
			c = a + b
			a = b
			b = c
			break if a >= NAN.maximumNumber 
			@numbers.push(a)
		###



class NAN.FibonacciNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "Fibonacci数"
		a = 0
		b = 1
		for i in [1..1000]
			c = a + b
			a = b
			b = c
			break if a >= NAN.maximumNumber 
			@numbers.push(a)
	

class NAN.PalindromicNumberSet extends NAN.NumberSet
	constructor: ()->
		@description = "回文数"

	analyze: (n)->
		if n.split("").reverse().join("") == n
			return {score: 10 * Math.pow(Math.max(n.length - 2, 0), 2), description: @description}
		return null

class NAN.prefixNumberSet extends NAN.NumberSet
	constructor: ()->
		@numbers = []
		@newNumber
			number: "31415926535",
			description: "圆周率",
			score: 60

		@newNumber
			number: "2718281828",
			description: "自然常数e",
			score: 60

		@newNumber
			number: "1414213562",
			description: "根号2",
			score: 40

	newNumber: (num)->
		@numbers.push
			number: num.number,
			description: num.description,
			score: num.score

	getResult: (n)->
		for numberInfo in @numbers
			if numberInfo.number.indexOf(n) == 0
				console.log(numberInfo.score, n.length)
				return {score: numberInfo.score * n.length * n.length, description: numberInfo.description + "的前#{n.length}位"}
		return null

	analyze: (n)->
		return null if n.length < 3
		return @getResult(n)


class NAN.meaningfulNumberSet extends NAN.NumberSet
	constructor: ()->
		@numbers = []

		@newNumber
			number: 42,
			description: "The answer to life,<br>the universe,<br>and everything",
			score: 100

		@newNumber
			number: 59,
			description: "挂科啦",
			score: 50

		@newNumber
			number: 63,
			description: "南南的生日",
			score: 200

		@newNumber
			number: 603,
			description: "南南的生日",
			score: 200

		@newNumber
			number: 60,
			description: "谢老师不挂之恩",
			score: 70

		@newNumber
			number: 360,
			description: "安全卫士",
			score: 70

		@newNumber
			number: 211,
			description: "开发者的狗窝",
			score: 70


		@newNumber
			number: 985,
			description: "看起来是一所好大学",
			score: 70

		@newNumber
			number: 250,
			description: "脑子出了点问题",
			score: 70

		@newNumber
			number: 100,
			description: "学霸你够了",
			score: 70

		@newNumber
			number: 99,
			description: "学霸你够了",
			score: 70

		@newNumber
			number: 233,
			description: "很好笑的样子",
			score: 70

		@newNumber
			number: 119,
			description: "着火啦",
			score: 70

		@newNumber
			number: 1024,
			description: "给你1024凑个整",
			score: 70


		@newNumber
			number: 404,
			description: "Not Found",
			score: 70

		@newNumber
			number: 520,
			description: "爱的誓言",
			score: 270

		@newNumber
			number: 521,
			description: "爱的誓言",
			score: 270

	newNumber: (num)->
		@numbers.push
			number: num.number,
			description: num.description,
			score: num.score

	getResult: (n)->
		for numberInfo in @numbers
			if numberInfo.number == n
				return {score: numberInfo.score, description: numberInfo.description}
		return null

	analyze: (n)->
		n = parseInt(n)
		return @getResult(n)
	
class NAN.Analyzer
	constructor: ()->
		@numberSets = []
		for key of NAN
			if key.toString().indexOf("NumberSet") > 0
				@numberSets.push(new NAN[key.toString()])

	analyze: (n)->
		score = 0
		descriptions = []
		propertiesCount = 0
		for numberSet in @numberSets
			result = numberSet.analyze(n)
			continue if result == null or result.score == 0
			score += result.score
			console.log(result.score, result.description)
			propertiesCount += 1
			descriptions.push(result.description)
		return {score: Math.floor(score * propertiesCount), descriptions: descriptions}
