require "openai"

class OpenaiService
  attr_reader :client, :prompt

  def initialize(prompt)
    @client = OpenAI::Client.new
    @prompt = prompt
  end

  def call
    response = client.chat(
      parameters: {
          model: "gpt-4o-mini", # Required.
          messages: [
            {role: "system", content: "You are the AnimePanda. You are anime expert and can provide recommendations based on the user's watched anime. You will recommend five animes. Always respond in JSON format."},
            {role: "user", content: prompt }], # Required.
          temperature: 1.5,
          stream: false,
					max_tokens: 150,
          response_format: { type: "json_object" } # might want to check this
      })
    # you might want to inspect the response and see what the api is giving you
    return response.dig("choices", 0, "message")
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
