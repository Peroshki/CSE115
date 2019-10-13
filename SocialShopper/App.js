import React, { Component } from 'react';
import { StyleSheet, View } from 'react-native';
import { Login } from './src/views/Login/Login.js';
import TabNavigator from './src/views/Menu/TabNavigator.js';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = { isLoggedIn: false };
    this.changeState = this.changeState.bind(this);
  }

  changeState() {
    this.setState({
      isLoggedIn: true
    })
  }

  render() {
    if (!this.state.isLoggedIn)
    {
      return (
        <View style={styles.container}>
          <Login changeState={this.changeState}/>
        </View>
      );
    }
    
    return (
      <View style={styles.container}>
          <TabNavigator/>
        </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1
  }
});

export default App;