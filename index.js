const { join_name: joinName } = require('./pkg/stash')

console.log('Your full name is ' + joinName({ first_name: 'John', last_name: 'Doe' }))
