# frozen_string_literal: true

require 'rspec-benchmark'
require_relative '../task-2'

RSpec.configure { |config| config.include RSpec::Benchmark::Matchers }

describe 'task_2' do
  let(:input_file_path) { 'spec/data/test_data.txt' }
  let(:output_file_path) { 'spec/data/test_result.json' }

  context 'when guarantee of correct execution  is tested' do
    subject(:generate_report) { work(input_file_path: input_file_path, output_file_path: output_file_path) }

    let(:control_result_file_path) { 'spec/data/expected_test_data_result.json' }
    let(:expected_result) { JSON.parse(File.read(control_result_file_path)) }

    it 'works correctly' do
      generate_report

      expect(JSON.parse(File.read(output_file_path))).to eq(expected_result)
    end
  end

  context 'when allocation is tested' do
    let(:maximum_objects_count) { 950 }

    it 'works faster than mimimum_ips ips' do
      expect { work(input_file_path: input_file_path, output_file_path: output_file_path) }
        .to perform_allocation(maximum_objects_count)
    end
  end

  context 'when the asymptotics is tested' do
    let(:data_range) { [1000, 2000, 4000, 8000] }

    it 'works like a linear algorithm' do
      expect { |n, _i| work(input_file_path: "spec/data/data-#{n}-lines.txt", output_file_path: output_file_path) }
        .to perform_power.in_range(data_range).threshold(0.1)
    end
  end
end
