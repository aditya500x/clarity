import { tasker_ai, paragraph_ai, chatbot_ai } from './index';

async function test() {
    console.log('Testing tasker_ai...');
    try {
        const taskResult = await tasker_ai('I need to fix the sink and buy a wrench.');
        console.log('tasker_ai result:', JSON.stringify(taskResult, null, 2));
    } catch (e) {
        console.error('tasker_ai failed:', e);
    }

    console.log('\nTesting paragraph_ai...');
    try {
        const paraResult = await paragraph_ai('The user interface is overly complex and contains too many flashing elements which are distracting.');
        console.log('paragraph_ai result:', JSON.stringify(paraResult, null, 2));
    } catch (e) {
        console.error('paragraph_ai failed:', e);
    }

    console.log('\nTesting chatbot_ai...');
    try {
        const chatResult = await chatbot_ai([
            { sender: 'user', text: 'Hi, I am feeling a bit overwhelmed.' },
            { sender: 'ai', text: 'I am here for you. What is on your mind?' },
            { sender: 'user', text: 'Just too many things to do.' }
        ]);
        console.log('chatbot_ai result:', JSON.stringify(chatResult, null, 2));
    } catch (e) {
        console.error('chatbot_ai failed:', e);
    }
}

test();
