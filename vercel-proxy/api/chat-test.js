// Test endpoint for chat functionality (no API key required)
export default async function handler(req, res) {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  // Handle OPTIONS request
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  // Only accept POST requests
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const { messages } = req.body;
    
    // Get the last user message
    const lastUserMessage = messages.filter(m => m.role === 'user').pop();
    const userText = lastUserMessage?.content || '';
    
    // Generate a test response based on user input
    let testResponse = "This is a test response from the AIMBTI Personal Advisor. ";
    
    if (userText.toLowerCase().includes('hello') || userText.toLowerCase().includes('hi')) {
      testResponse += "Hello! I'm your MBTI personal advisor. How can I help you today?";
    } else if (userText.toLowerCase().includes('mbti')) {
      testResponse += "MBTI is a personality assessment tool that categorizes individuals into 16 personality types based on four dimensions: Extraversion/Introversion, Sensing/Intuition, Thinking/Feeling, and Judging/Perceiving.";
    } else if (userText.toLowerCase().includes('test')) {
      testResponse += "The chat functionality is working correctly! Once you add your OpenAI API key, I'll be able to provide personalized MBTI guidance.";
    } else {
      testResponse += "I'm currently in test mode. Please add your OpenAI API key to enable full functionality. For now, I can confirm that the chat system is working properly!";
    }
    
    // Return OpenAI-compatible response format
    const response = {
      id: "test-" + Date.now(),
      object: "chat.completion",
      created: Math.floor(Date.now() / 1000),
      model: "test-model",
      choices: [{
        index: 0,
        message: {
          role: "assistant",
          content: testResponse
        },
        finish_reason: "stop"
      }],
      usage: {
        prompt_tokens: 0,
        completion_tokens: 0,
        total_tokens: 0
      }
    };
    
    res.status(200).json(response);
    
  } catch (error) {
    console.error('Test endpoint error:', error);
    res.status(500).json({ error: 'Test endpoint error' });
  }
}