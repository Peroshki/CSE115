import React, { Component } from "react";
import { StyleSheet, Text, View, Image, TouchableOpacity, KeyboardAvoidingView } from 'react-native';
import LoginForm from './LoginForm';

export class Login extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <KeyboardAvoidingView behavior='padding' style={styles.container}>
                <View style={styles.logoContainer}>
                    <Image style={styles.logo} source={require('../../../assets/git.png')}/>
                    <Text style={styles.title}>This is a logo</Text>
                </View>
                <View>
                   <LoginForm/>
                </View>

                <TouchableOpacity 
                style={styles.buttonContainer}
                onPress={this.props.changeState}
                >
                    <Text style={styles.buttonText}>Login</Text>
                </TouchableOpacity>
            </KeyboardAvoidingView>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#3498db'
    },

    logoContainer: {
        alignItems: 'center',
        flexGrow: 1,
        justifyContent: 'center'
    },

    logo: {
        width: 100,
        height: 100
    },

    title: {
        color: '#FFF',
        marginTop: 10,
        width: 100,
        textAlign: 'center',
        opacity: 0.9
    },
    
    buttonContainer: {
        backgroundColor: '#2980b9',
        paddingVertical: 15
    },
    
    buttonText: {
        textAlign: 'center',
        color: "#FFF",
        fontWeight: '700'
    }
});