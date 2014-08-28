'use strict'

express = require 'express'
fs = require 'fs'
request = require 'request'

cheerio = require 'cheerio'
app = express()

app.get '/scrape', (req, res) ->
	url = 'http://www.imdb.com/title/tt1229340/';
	request url, (err, response, html) ->
		if !err
			$ = cheerio.load html
			json =
				title: ""
				release: ""
				rating: ""
			$('.header').filter () ->
				data = $(this)

				title = data.children().first().text()

				release = data.children().last().children().text()
				
				json.title = title
				json.release = release
				return
			$('.star-box-giga-star').filter () ->
				data = $(this)
				rating = data.text()
				json.rating = rating
				return

		fs.writeFile 'output.json', JSON.stringify(json, null, 4), (err) ->
			console.log 'File successfully written!'
			return
		res.send 'check your console!!'
		return
.listen '9009', () ->
	console.log 'Server was running at port 9009'
	return
