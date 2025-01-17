import React from 'react';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { BarChart, Bar, PieChart, Pie, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, Cell } from 'recharts';

const CreditRiskDashboard = () => {
  // Data for credit score distribution
  const creditScoreData = [
    { range: 'Poor (<580)', count: 50000 },
    { range: 'Fair (580-669)', count: 15000 },
    { range: 'Good (670-739)', count: 12000 },
    { range: 'Very Good (740-799)', count: 10000 },
    { range: 'Excellent (800+)', count: 8000 }
  ];

  // Data for risk distribution
  const riskData = [
    { name: 'High Risk', value: 55 },
    { name: 'Medium Risk', value: 27 },
    { name: 'Low Risk', value: 18 }
  ];

  // Data for loan purpose distribution
  const loanPurposeData = [
    { purpose: 'Car', count: 20000 },
    { purpose: 'Education', count: 20000 },
    { purpose: 'Business', count: 20000 },
    { purpose: 'Home', count: 20000 },
    { purpose: 'Personal', count: 20000 }
  ];

  // Data for age distribution
  const ageData = [
    { range: '18-25', count: 15000 },
    { range: '26-35', count: 18000 },
    { range: '36-45', count: 18500 },
    { range: '46-55', count: 18000 },
    { range: '55+', count: 27000 }
  ];

  const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042', '#8884d8'];

  return (
    <div className="p-4 bg-gray-50">
      <Card className="mb-6">
        <CardHeader>
          <CardTitle className="text-2xl text-center">Financial Analytics Dashboard</CardTitle>
        </CardHeader>
      </Card>
      
      <div className="grid grid-cols-4 gap-4 mb-4">
        <Card className="p-4">
          <CardTitle className="text-lg mb-2">Total Applicants</CardTitle>
          <div className="text-3xl font-bold">100,000</div>
        </Card>
        <Card className="p-4">
          <CardTitle className="text-lg mb-2">Average Loan Amount</CardTitle>
          <div className="text-3xl font-bold">$252,950.36</div>
        </Card>
        <Card className="p-4">
          <CardTitle className="text-lg mb-2">Max DTI Ratio</CardTitle>
          <div className="text-3xl font-bold">3.95</div>
        </Card>
        <Card className="p-4">
          <CardTitle className="text-lg mb-2">Min Credit Score</CardTitle>
          <div className="text-3xl font-bold">500</div>
        </Card>
      </div>

      <div className="grid grid-cols-2 gap-4">
        <Card className="p-4">
          <CardTitle className="text-lg mb-4">Risk Distribution</CardTitle>
          <PieChart width={400} height={300}>
            <Pie
              data={riskData}
              cx="50%"
              cy="50%"
              outerRadius={100}
              fill="#8884d8"
              dataKey="value"
              label
            >
              {riskData.map((entry, index) => (
                <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
              ))}
            </Pie>
            <Tooltip />
            <Legend />
          </PieChart>
        </Card>

        <Card className="p-4">
          <CardTitle className="text-lg mb-4">Credit Score Distribution</CardTitle>
          <BarChart width={400} height={300} data={creditScoreData}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="range" />
            <YAxis />
            <Tooltip />
            <Bar dataKey="count" fill="#82ca9d" />
          </BarChart>
        </Card>

        <Card className="p-4">
          <CardTitle className="text-lg mb-4">Loan Purpose Distribution</CardTitle>
          <BarChart width={400} height={300} data={loanPurposeData}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="purpose" />
            <YAxis />
            <Tooltip />
            <Bar dataKey="count" fill="#8884d8" />
          </BarChart>
        </Card>

        <Card className="p-4">
          <CardTitle className="text-lg mb-4">Age Distribution</CardTitle>
          <BarChart width={400} height={300} data={ageData}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="range" />
            <YAxis />
            <Tooltip />
            <Bar dataKey="count" fill="#ffc658" />
          </BarChart>
        </Card>
      </div>
    </div>
  );
};

export default CreditRiskDashboard;
