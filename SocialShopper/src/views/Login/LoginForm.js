// import libraries
import React, { Component } from 'react';
import { StyleSheet, View, TextInput } from 'react-native';

// create a component
class filename extends Component {
    render() {
        return (
            <View style={styles.container}>
                <TextInput 
                style={styles.input}
                placeholder="username or email"
                placeholderTextColor='rgba(255,255,255,0.7)'
                returnKeyType="next"
                onSubmitEditing={() => this.passwordInput.focus()}
                keyboardType='email-address'
                autoCapitalize='none'
                />

                <TextInput 
                style={styles.input}
                placeholder="password"
                placeholderTextColor='rgba(255,255,255,0.7)'
                returnKeyType="go"
                secureTextEntry
                ref={(input) => this.passwordInput = input}
                />
            </View>
        );
    }
}

// define your styles
const styles = StyleSheet.create({
    container: {
        padding: 20
    },

    input: {
        height: 40,
        backgroundColor: 'rgba(255,255,255,0.2)',
        color: '#FFF',
        marginBottom: 10,
        paddingHorizontal: 10
    }
});

// make this component available to the app
export default filename;
