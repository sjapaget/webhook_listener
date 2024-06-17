require 'sinatra'
require 'json'
require 'rugged'
require 'openssl'

set :port, 2024

REPO_PATH = 'path to repo'
SECRET_TOKEN = 'github webhook secret'

post '/payload' do
    request.body.rewind
    payload_body = request.body.read
    verify_signature(payload_body)

    push = JSON.parse(payload_body)

    if push['ref'] == 'refs/heads/main'
        repo = Rugged::Repository.new(REPO_PATH)
        repo.remotes['origin'].fetch
        repo.checkout('refs/remotes/origin/main', strategy: :force)
        "Repository updated"
    else
        status 204
    end
end

def verify_signature(payload_body)
    signature = 'sha256=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), SECRET_TOKEN, payload_body)
    return halt 403, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE_256'])
end
