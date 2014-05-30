window.NAN.maximumNumber = 100000000

class NAN.NumberSet
	constructor: ()->
		@description = "Interesting Number"
		@numbers = []
		@filters = []
		@addFilter(@lengthFilter)

	lengthFilter: (n)=>
		console.log(34333333333)
		console.log(@minLength)
		if @minLength
			if n.length < @minLength
				return {score: 0, description: "略短的"}
		return true

	getDescription: ()=>
		return @description

	listFilter: (n)=>
		if parseInt(n) in @numbers
			return true
		return null

	primeFilter: (n)->
		n = parseInt(n)
		if n == 2
			return true
		if n < 2
			return null
		a = 2
		while a * a <= n
			if n % a == 0
				return null
			a += 1
		return true

	addFilter: (func)->
		@filters.push(func)

	evaluate: ()->
		console.log("!!!!")


	sqrtEvalutor: (n)->
		return 100 + Math.sqrt(parseInt(n), 1)


	lengthEvalutor: (n)->
		return 10 * Math.pow(n.length, 1)

	lengthEvalutor2: (n)->
		return 10 * Math.pow(n.length, 2)

	lengthEvalutor3: (n)->
		return 10 * Math.pow(n.length, 3)

	logEvalutor: (n)->
		return 30 + 5 * Math.pow(Math.log(parseInt(n)), 2.5)
	
	analyze: (n)->
		result = {score: 1, description: ""}
		for filter in @filters
			info = filter(n)
			console.log(info)
			if info == null
				return null
			if info == true
				continue
			result.score *= info.score
			result.description += info.description
		console.log(result)
		result.score *= @evaluate(n)
		result.description += @getDescription()
		console.log(result)
		return result

class NAN.PrimeNumberSet extends NAN.NumberSet

	constructor: ()->
		super()
		@description = "质数"
		@addFilter(@primeFilter)
		@evaluate = @logEvalutor

class NAN.PureOddNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "纯奇数"
		@minLength = 4
		@addFilter(@filter)
		@evaluate = @lengthEvalutor

	filter: (n)->
		for char in n
			if parseInt(char) % 2 == 0
				return null
		return {score: 1, description: ""}

class NAN.PureEvenNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "纯偶数"
		@minLength = 4
		@addFilter(@filter)
		@evaluate = @lengthEvalutor

	filter: (n)->
		for char in n
			if parseInt(char) % 2 == 1
				return null
		return {score: 1, description: ""}

class NAN.PureNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "纯数"
		@minLength = 3
		@addFilter(@filter)
		@evaluate = @lengthEvalutor2

	filter: (n)->
		for char in n
			if char != n[0]
				return null
		return {score: 1, description: ""}


class NAN.APNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "等差数列数"
		@minLength = 3
		@addFilter(@filter)
		@evaluate = @lengthEvalutor2

	filter: (n)=>
		if n.length < 3
			return null
		delta = -11
		for i in [0...n.length - 1]
			newDelta = (n[i + 1] - n[i])
			if newDelta == 0
				return null
			if delta == -10
				delta = newDelta
			else 
				if delta != newDelta
					return null
		return true

class NAN.LoopNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "周期数"
		@minLength = 3
		@addFilter(@filter)
		@evaluate = @lengthEvalutor2

	filter: (n)=>
		if n.length < 3
			return null
		for i in [2...n.length - 1]
			continue if n.length % i != 0
			k = n.length / i
			flag = true
			for p in [0...i]
				for j in [1...k]
					if n[p + i * j] != n[p]
						flag = false
			if flag
				return true
		return null

class NAN.MultipleNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "多重数"
		@minLength = 3
		@addFilter(@filter)
		@evaluate = @lengthEvalutor2

	filter: (n)=>
		if n.length < 3
			return null
		for i in [2...n.length - 1]
			continue if n.length % i != 0
			k = n.length / i
			flag = true
			for j in [0...k]
				for p in [i * j...i * (j + 1)]
					if n[p] != n[i * j]
						flag = false
			if flag
				return true
		return null


class NAN.WaveNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "波浪数"
		@minLength = 3
		@addFilter(@filter)
		@evaluate = @lengthEvalutor2

	filter: (n)=>
		return null if n.length < 3 
		lastDelta = 0
		for i in [0...n.length - 1]
			newDelta = (n[i + 1] - n[i])
			return null if Math.abs(newDelta) != 1
			if lastDelta != 0 and newDelta + lastDelta != 0
				return null
			lastDelta = newDelta
		return true


class NAN.PowerNumberSet extends NAN.NumberSet
	constructor: ()->
		super()

	analyze: (n)->
		n = parseInt(n)
		for k in [2..100].reverse()
			base = Math.round(Math.pow(n, 1.0 / k))
#			console.log(base)
			tmp = "#{k}次方"
			if k == 2
				tmp = "平方"
			if k == 3
				tmp = "立方"
			if Math.pow(base, k) == n
				return {score: k * k * base, description: "#{base}的#{tmp}"}
		return null

class NAN.CloseToSomePowerOf2NumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "接近2的幂"
		a = 1
		while a < NAN.maximumNumber
			@numbers.push(a + 1)
			@numbers.push(a - 1)

			a *= 2
		@filters = [@listFilter]
		@evaluate = (n)=>
			@sqrtEvalutor(n) / 4


class NAN.FactorialNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "阶乘数"
		a = 1
		for i in [1..100]
			a = a * i
			break if a >= NAN.maximumNumber 
			@numbers.push(a)
		@filters = [@listFilter]
		@evaluate = (n)=>
			@sqrtEvalutor(n)

class NAN.HundredNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "除了开头全是0"
		a = 1
		for i in [1..1000]
			a = a * 10
			for b in [1..9]
				break if a * b >= NAN.maximumNumber 
				@numbers.push(a * b)
		@filters = [@listFilter]
		@evaluate = (n)=>
			@sqrtEvalutor(n) / 10

class NAN.AutomorphicNumberNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@description = "自守数"
		@addFilter( (n)=>
			if Math.pow(parseInt(n), 2).toString().split("").reverse().join("").indexOf(n.split("").reverse().join("")) == 0
				return true
			return null
		)
		@evaluate = @sqrtEvalutor


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
		@filters = [@listFilter]
		@evaluate = (n)=>
			Math.pow(parseInt(n), 0.6)

class NAN.PalindromicNumberSet extends NAN.NumberSet
	constructor: ()->
		super()
		@minLength = 3
		@description = "回文数"
		@evaluate = @sqrtEvalutor
		@addFilter((n)->
			if n.split("").reverse().join("") == n
				return true
			return null
		)

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
			description: "大脑似乎出了点问题",
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
			number: 120,
			description: "救护车?",
			score: 70

		@newNumber
			number: 110,
			description: "救命!",
			score: 70


		@newNumber
			number: 12306,
			description: "和谐号",
			score: 70


		@newNumber
			number: 95566,
			description: "中国银行",
			score: 70

		@newNumber
			number: 1024,
			description: "凑个整",
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

		@newNumber
			number: 23,
			description: "就知道23",
			score: 20

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
			console.log(result)
			continue if result == null
			result.score = Math.round(result.score)
			score += result.score
			propertiesCount += 1
			descriptions.push(result.description)
		info = {score: Math.floor(score * propertiesCount), descriptions: descriptions}
		console.log(info)
		return info
