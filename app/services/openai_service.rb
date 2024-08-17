require "openai"

class OpenaiService
  attr_reader :client, :prompt

  def initialize
    @client = OpenAI::Client.new
  end

  def recommend_anime(prompt)
    response = client.chat(
      parameters: {
          model: "gpt-4o-mini", # Required.
          messages: [
            {role: "system", content: "You are the AnimePanda. ndations based on the user's watched anime. You will recommend five animes. Always respond in JSON format."},
            {role: "user", content: prompt }], # Required.
          temperature: 1.5,
          stream: false,
					max_tokens: 150,
          response_format: { type: "json_object" } # might want to check this
      })
    # you might want to inspect the response and see what the api is giving you
    return response.dig("choices", 0, "message")
  end


  def home_chat
    response = client.chat(
      parameters: {
          model: "gpt-4o-mini", # Required.
          messages: [
            {role: "system", content: "You are the AnimePanda. You are an anime expert and concierge for an anime recommendations website. When the user goes the homepage send a welcome message in a funny and quirky way "},
            {role: "user", content: "I just got to the homepage. Send me a welcome message. Keep it short and less than 10 words" }], # Required.
          temperature: 1.5,
          stream: false,
					max_tokens: 150,
      })
    # you might want to inspect the response and see what the api is giving you
    return response.dig("choices", 0, "message", "content")
  end

  def extract_json(input_string)
    # Define a regular expression to match JSON block
    json_pattern = /```json\n(.*)\n```/m

    # Find the JSON block in the input string
    match = input_string.match(json_pattern)

    # Extract the JSON part if matched
    json_string = match[1] if match

    # Parse the JSON string
    JSON.parse(json_string) if json_string
  rescue JSON::ParserError => e
    puts "Failed to parse JSON: #{e.message}"
    nil
  end

end
