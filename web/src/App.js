import React, { Component } from 'react'

import Concerts from './Concerts'

class App extends Component {
  render() {
    return (
      <div className="App">
        <div className="container">
          <Concerts/>
        </div>
      </div>
    );
  }
}

export default App
