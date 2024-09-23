// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

package org.apache.doris.nereids.trees.expressions.functions.agg;

import org.apache.doris.catalog.FunctionSignature;
import org.apache.doris.nereids.exceptions.AnalysisException;
import org.apache.doris.nereids.trees.expressions.Expression;
import org.apache.doris.nereids.trees.expressions.functions.AlwaysNotNullable;
import org.apache.doris.nereids.trees.expressions.functions.ExplicitlyCastableSignature;
import org.apache.doris.nereids.trees.expressions.functions.scalar.QuantileStateEmpty;
import org.apache.doris.nereids.trees.expressions.shape.UnaryExpression;
import org.apache.doris.nereids.trees.expressions.visitor.ExpressionVisitor;
import org.apache.doris.nereids.types.DataType;
import org.apache.doris.nereids.types.QuantileStateType;

import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;

import java.util.List;

/**
 * AggregateFunction 'quantile_union'. This class is generated by GenerateFunction.
 */
public class QuantileUnion extends AggregateFunction
        implements UnaryExpression, ExplicitlyCastableSignature, AlwaysNotNullable {

    public static final List<FunctionSignature> SIGNATURES = ImmutableList.of(
            FunctionSignature.ret(QuantileStateType.INSTANCE).args(QuantileStateType.INSTANCE)
    );

    /**
     * constructor with 1 argument.
     */
    public QuantileUnion(Expression arg) {
        super("quantile_union", arg);
    }

    /**
     * constructor with 1 argument.
     */
    public QuantileUnion(boolean distinct, Expression arg) {
        super("quantile_union", distinct, arg);
    }

    @Override
    public void checkLegalityBeforeTypeCoercion() {
        DataType inputType = getArgumentType(0);
        if (!inputType.isQuantileStateType()) {
            throw new AnalysisException(getName()
                    + " function's argument should be of QUANTILE_STATE type, but was" + inputType);
        }
    }

    /**
     * withDistinctAndChildren.
     */
    @Override
    public QuantileUnion withDistinctAndChildren(boolean distinct, List<Expression> children) {
        Preconditions.checkArgument(children.size() == 1);
        return new QuantileUnion(distinct, children.get(0));
    }

    @Override
    public <R, C> R accept(ExpressionVisitor<R, C> visitor, C context) {
        return visitor.visitQuantileUnion(this, context);
    }

    @Override
    public List<FunctionSignature> getSignatures() {
        return SIGNATURES;
    }

    @Override
    public Expression resultForEmptyInput() {
        return new QuantileStateEmpty();
    }
}
