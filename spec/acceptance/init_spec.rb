require 'spec_helper_acceptance'

describe 'p4api class' do
  context 'with required parameters only' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = %{
        include p4api
      }

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

  end
end
