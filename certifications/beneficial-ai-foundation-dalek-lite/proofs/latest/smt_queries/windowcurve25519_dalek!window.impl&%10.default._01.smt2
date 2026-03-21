(set-option :auto_config false)
(set-option :smt.mbqi false)
(set-option :smt.case_split 3)
(set-option :smt.qi.eager_threshold 100.0)
(set-option :smt.delay_units true)
(set-option :smt.arith.solver 2)
(set-option :smt.arith.nl false)
(set-option :pi.enabled false)
(set-option :rewriter.sort_disjunctions false)

;; Prelude

;; AIR prelude
(declare-sort %%Function%% 0)

(declare-sort FuelId 0)
(declare-sort Fuel 0)
(declare-const zero Fuel)
(declare-fun succ (Fuel) Fuel)
(declare-fun fuel_bool (FuelId) Bool)
(declare-fun fuel_bool_default (FuelId) Bool)
(declare-const fuel_defaults Bool)
(assert
 (=>
  fuel_defaults
  (forall ((id FuelId)) (!
    (= (fuel_bool id) (fuel_bool_default id))
    :pattern ((fuel_bool id))
    :qid prelude_fuel_defaults
    :skolemid skolem_prelude_fuel_defaults
))))
(declare-datatypes ((fndef 0)) (((fndef_singleton))))
(declare-sort Poly 0)
(declare-sort Height 0)
(declare-fun I (Int) Poly)
(declare-fun B (Bool) Poly)
(declare-fun R (Real) Poly)
(declare-fun F (fndef) Poly)
(declare-fun %I (Poly) Int)
(declare-fun %B (Poly) Bool)
(declare-fun %R (Poly) Real)
(declare-fun %F (Poly) fndef)
(declare-sort Type 0)
(declare-const BOOL Type)
(declare-const INT Type)
(declare-const NAT Type)
(declare-const REAL Type)
(declare-const CHAR Type)
(declare-const USIZE Type)
(declare-const ISIZE Type)
(declare-const TYPE%tuple%0. Type)
(declare-fun UINT (Int) Type)
(declare-fun SINT (Int) Type)
(declare-fun FLOAT (Int) Type)
(declare-fun CONST_INT (Int) Type)
(declare-fun CONST_BOOL (Bool) Type)
(declare-sort Dcr 0)
(declare-const $ Dcr)
(declare-const $slice Dcr)
(declare-const $dyn Dcr)
(declare-fun DST (Dcr) Dcr)
(declare-fun REF (Dcr) Dcr)
(declare-fun MUT_REF (Dcr) Dcr)
(declare-fun BOX (Dcr Type Dcr) Dcr)
(declare-fun RC (Dcr Type Dcr) Dcr)
(declare-fun ARC (Dcr Type Dcr) Dcr)
(declare-fun GHOST (Dcr) Dcr)
(declare-fun TRACKED (Dcr) Dcr)
(declare-fun NEVER (Dcr) Dcr)
(declare-fun CONST_PTR (Dcr) Dcr)
(declare-fun ARRAY (Dcr Type Dcr Type) Type)
(declare-fun MUTREF (Dcr Type) Type)
(declare-fun SLICE (Dcr Type) Type)
(declare-const STRSLICE Type)
(declare-const ALLOCATOR_GLOBAL Type)
(declare-fun PTR (Dcr Type) Type)
(declare-fun has_type (Poly Type) Bool)
(declare-fun sized (Dcr) Bool)
(declare-fun as_type (Poly Type) Poly)
(declare-fun mk_fun (%%Function%%) %%Function%%)
(declare-fun const_int (Type) Int)
(declare-fun const_bool (Type) Bool)
(declare-fun mut_ref_current% (Poly) Poly)
(declare-fun mut_ref_future% (Poly) Poly)
(declare-fun mut_ref_update_current% (Poly Poly) Poly)
(assert
 (forall ((m Poly) (arg Poly)) (!
   (= (mut_ref_current% (mut_ref_update_current% m arg)) arg)
   :pattern ((mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_current_current
   :skolemid skolem_prelude_mut_ref_update_current_current
)))
(assert
 (forall ((m Poly) (arg Poly)) (!
   (= (mut_ref_future% (mut_ref_update_current% m arg)) (mut_ref_future% m))
   :pattern ((mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_current_future
   :skolemid skolem_prelude_mut_ref_update_current_future
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type)) (!
   (=>
    (has_type m (MUTREF d t))
    (has_type (mut_ref_current% m) t)
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_current% m))
   :qid prelude_mut_ref_current_has_type
   :skolemid skolem_prelude_mut_ref_current_has_type
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type)) (!
   (=>
    (has_type m (MUTREF d t))
    (has_type (mut_ref_future% m) t)
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_future% m))
   :qid prelude_mut_ref_current_has_type
   :skolemid skolem_prelude_mut_ref_current_has_type
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type) (arg Poly)) (!
   (=>
    (and
     (has_type m (MUTREF d t))
     (has_type arg t)
    )
    (has_type (mut_ref_update_current% m arg) (MUTREF d t))
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_has_type
   :skolemid skolem_prelude_mut_ref_update_has_type
)))
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (sized (DST d))
   )
   :pattern ((sized (DST d)))
   :qid prelude_sized_decorate_struct_inherit
   :skolemid skolem_prelude_sized_decorate_struct_inherit
)))
(assert
 (forall ((d Dcr)) (!
   (sized (REF d))
   :pattern ((sized (REF d)))
   :qid prelude_sized_decorate_ref
   :skolemid skolem_prelude_sized_decorate_ref
)))
(assert
 (forall ((d Dcr)) (!
   (sized (MUT_REF d))
   :pattern ((sized (MUT_REF d)))
   :qid prelude_sized_decorate_mut_ref
   :skolemid skolem_prelude_sized_decorate_mut_ref
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (BOX d t d2))
   :pattern ((sized (BOX d t d2)))
   :qid prelude_sized_decorate_box
   :skolemid skolem_prelude_sized_decorate_box
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (RC d t d2))
   :pattern ((sized (RC d t d2)))
   :qid prelude_sized_decorate_rc
   :skolemid skolem_prelude_sized_decorate_rc
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (ARC d t d2))
   :pattern ((sized (ARC d t d2)))
   :qid prelude_sized_decorate_arc
   :skolemid skolem_prelude_sized_decorate_arc
)))
(assert
 (forall ((d Dcr)) (!
   (sized (GHOST d))
   :pattern ((sized (GHOST d)))
   :qid prelude_sized_decorate_ghost
   :skolemid skolem_prelude_sized_decorate_ghost
)))
(assert
 (forall ((d Dcr)) (!
   (sized (TRACKED d))
   :pattern ((sized (TRACKED d)))
   :qid prelude_sized_decorate_tracked
   :skolemid skolem_prelude_sized_decorate_tracked
)))
(assert
 (forall ((d Dcr)) (!
   (sized (NEVER d))
   :pattern ((sized (NEVER d)))
   :qid prelude_sized_decorate_never
   :skolemid skolem_prelude_sized_decorate_never
)))
(assert
 (forall ((d Dcr)) (!
   (sized (CONST_PTR d))
   :pattern ((sized (CONST_PTR d)))
   :qid prelude_sized_decorate_const_ptr
   :skolemid skolem_prelude_sized_decorate_const_ptr
)))
(assert
 (sized $)
)
(assert
 (forall ((i Int)) (!
   (= i (const_int (CONST_INT i)))
   :pattern ((CONST_INT i))
   :qid prelude_type_id_const_int
   :skolemid skolem_prelude_type_id_const_int
)))
(assert
 (forall ((b Bool)) (!
   (= b (const_bool (CONST_BOOL b)))
   :pattern ((CONST_BOOL b))
   :qid prelude_type_id_const_bool
   :skolemid skolem_prelude_type_id_const_bool
)))
(assert
 (forall ((b Bool)) (!
   (has_type (B b) BOOL)
   :pattern ((has_type (B b) BOOL))
   :qid prelude_has_type_bool
   :skolemid skolem_prelude_has_type_bool
)))
(assert
 (forall ((r Real)) (!
   (has_type (R r) REAL)
   :pattern ((has_type (R r) REAL))
   :qid prelude_has_type_real
   :skolemid skolem_prelude_has_type_real
)))
(assert
 (forall ((x Poly) (t Type)) (!
   (and
    (has_type (as_type x t) t)
    (=>
     (has_type x t)
     (= x (as_type x t))
   ))
   :pattern ((as_type x t))
   :qid prelude_as_type
   :skolemid skolem_prelude_as_type
)))
(assert
 (forall ((x %%Function%%)) (!
   (= (mk_fun x) x)
   :pattern ((mk_fun x))
   :qid prelude_mk_fun
   :skolemid skolem_prelude_mk_fun
)))
(assert
 (forall ((x Bool)) (!
   (= x (%B (B x)))
   :pattern ((B x))
   :qid prelude_unbox_box_bool
   :skolemid skolem_prelude_unbox_box_bool
)))
(assert
 (forall ((x Int)) (!
   (= x (%I (I x)))
   :pattern ((I x))
   :qid prelude_unbox_box_int
   :skolemid skolem_prelude_unbox_box_int
)))
(assert
 (forall ((x Real)) (!
   (= x (%R (R x)))
   :pattern ((R x))
   :qid prelude_unbox_box_real
   :skolemid skolem_prelude_unbox_box_real
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x BOOL)
    (= x (B (%B x)))
   )
   :pattern ((has_type x BOOL))
   :qid prelude_box_unbox_bool
   :skolemid skolem_prelude_box_unbox_bool
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x INT)
    (= x (I (%I x)))
   )
   :pattern ((has_type x INT))
   :qid prelude_box_unbox_int
   :skolemid skolem_prelude_box_unbox_int
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x NAT)
    (= x (I (%I x)))
   )
   :pattern ((has_type x NAT))
   :qid prelude_box_unbox_nat
   :skolemid skolem_prelude_box_unbox_nat
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x USIZE)
    (= x (I (%I x)))
   )
   :pattern ((has_type x USIZE))
   :qid prelude_box_unbox_usize
   :skolemid skolem_prelude_box_unbox_usize
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ISIZE)
    (= x (I (%I x)))
   )
   :pattern ((has_type x ISIZE))
   :qid prelude_box_unbox_isize
   :skolemid skolem_prelude_box_unbox_isize
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (UINT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (UINT bits)))
   :qid prelude_box_unbox_uint
   :skolemid skolem_prelude_box_unbox_uint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (SINT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (SINT bits)))
   :qid prelude_box_unbox_sint
   :skolemid skolem_prelude_box_unbox_sint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (FLOAT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (FLOAT bits)))
   :qid prelude_box_unbox_sint
   :skolemid skolem_prelude_box_unbox_sint
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x CHAR)
    (= x (I (%I x)))
   )
   :pattern ((has_type x CHAR))
   :qid prelude_box_unbox_char
   :skolemid skolem_prelude_box_unbox_char
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x REAL)
    (= x (R (%R x)))
   )
   :pattern ((has_type x REAL))
   :qid prelude_box_unbox_real
   :skolemid skolem_prelude_box_unbox_real
)))
(declare-fun ext_eq (Bool Type Poly Poly) Bool)
(assert
 (forall ((deep Bool) (t Type) (x Poly) (y Poly)) (!
   (= (= x y) (ext_eq deep t x y))
   :pattern ((ext_eq deep t x y))
   :qid prelude_ext_eq
   :skolemid skolem_prelude_ext_eq
)))
(declare-const SZ Int)
(assert
 (or
  (= SZ 32)
  (= SZ 64)
))
(declare-fun uHi (Int) Int)
(declare-fun iLo (Int) Int)
(declare-fun iHi (Int) Int)
(assert
 (= (uHi 8) 256)
)
(assert
 (= (uHi 16) 65536)
)
(assert
 (= (uHi 32) 4294967296)
)
(assert
 (= (uHi 64) 18446744073709551616)
)
(assert
 (= (uHi 128) (+ 1 340282366920938463463374607431768211455))
)
(assert
 (= (iLo 8) (- 128))
)
(assert
 (= (iLo 16) (- 32768))
)
(assert
 (= (iLo 32) (- 2147483648))
)
(assert
 (= (iLo 64) (- 9223372036854775808))
)
(assert
 (= (iLo 128) (- 170141183460469231731687303715884105728))
)
(assert
 (= (iHi 8) 128)
)
(assert
 (= (iHi 16) 32768)
)
(assert
 (= (iHi 32) 2147483648)
)
(assert
 (= (iHi 64) 9223372036854775808)
)
(assert
 (= (iHi 128) 170141183460469231731687303715884105728)
)
(declare-fun nClip (Int) Int)
(declare-fun uClip (Int Int) Int)
(declare-fun iClip (Int Int) Int)
(declare-fun charClip (Int) Int)
(assert
 (forall ((i Int)) (!
   (and
    (<= 0 (nClip i))
    (=>
     (<= 0 i)
     (= i (nClip i))
   ))
   :pattern ((nClip i))
   :qid prelude_nat_clip
   :skolemid skolem_prelude_nat_clip
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (and
    (<= 0 (uClip bits i))
    (< (uClip bits i) (uHi bits))
    (=>
     (and
      (<= 0 i)
      (< i (uHi bits))
     )
     (= i (uClip bits i))
   ))
   :pattern ((uClip bits i))
   :qid prelude_u_clip
   :skolemid skolem_prelude_u_clip
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (and
    (<= (iLo bits) (iClip bits i))
    (< (iClip bits i) (iHi bits))
    (=>
     (and
      (<= (iLo bits) i)
      (< i (iHi bits))
     )
     (= i (iClip bits i))
   ))
   :pattern ((iClip bits i))
   :qid prelude_i_clip
   :skolemid skolem_prelude_i_clip
)))
(assert
 (forall ((i Int)) (!
   (and
    (or
     (and
      (<= 0 (charClip i))
      (<= (charClip i) 55295)
     )
     (and
      (<= 57344 (charClip i))
      (<= (charClip i) 1114111)
    ))
    (=>
     (or
      (and
       (<= 0 i)
       (<= i 55295)
      )
      (and
       (<= 57344 i)
       (<= i 1114111)
     ))
     (= i (charClip i))
   ))
   :pattern ((charClip i))
   :qid prelude_char_clip
   :skolemid skolem_prelude_char_clip
)))
(declare-fun uInv (Int Int) Bool)
(declare-fun iInv (Int Int) Bool)
(declare-fun charInv (Int) Bool)
(assert
 (forall ((bits Int) (i Int)) (!
   (= (uInv bits i) (and
     (<= 0 i)
     (< i (uHi bits))
   ))
   :pattern ((uInv bits i))
   :qid prelude_u_inv
   :skolemid skolem_prelude_u_inv
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (= (iInv bits i) (and
     (<= (iLo bits) i)
     (< i (iHi bits))
   ))
   :pattern ((iInv bits i))
   :qid prelude_i_inv
   :skolemid skolem_prelude_i_inv
)))
(assert
 (forall ((i Int)) (!
   (= (charInv i) (or
     (and
      (<= 0 i)
      (<= i 55295)
     )
     (and
      (<= 57344 i)
      (<= i 1114111)
   )))
   :pattern ((charInv i))
   :qid prelude_char_inv
   :skolemid skolem_prelude_char_inv
)))
(assert
 (forall ((x Int)) (!
   (has_type (I x) INT)
   :pattern ((has_type (I x) INT))
   :qid prelude_has_type_int
   :skolemid skolem_prelude_has_type_int
)))
(assert
 (forall ((x Int)) (!
   (=>
    (<= 0 x)
    (has_type (I x) NAT)
   )
   :pattern ((has_type (I x) NAT))
   :qid prelude_has_type_nat
   :skolemid skolem_prelude_has_type_nat
)))
(assert
 (forall ((x Int)) (!
   (=>
    (uInv SZ x)
    (has_type (I x) USIZE)
   )
   :pattern ((has_type (I x) USIZE))
   :qid prelude_has_type_usize
   :skolemid skolem_prelude_has_type_usize
)))
(assert
 (forall ((x Int)) (!
   (=>
    (iInv SZ x)
    (has_type (I x) ISIZE)
   )
   :pattern ((has_type (I x) ISIZE))
   :qid prelude_has_type_isize
   :skolemid skolem_prelude_has_type_isize
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (uInv bits x)
    (has_type (I x) (UINT bits))
   )
   :pattern ((has_type (I x) (UINT bits)))
   :qid prelude_has_type_uint
   :skolemid skolem_prelude_has_type_uint
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (iInv bits x)
    (has_type (I x) (SINT bits))
   )
   :pattern ((has_type (I x) (SINT bits)))
   :qid prelude_has_type_sint
   :skolemid skolem_prelude_has_type_sint
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (uInv bits x)
    (has_type (I x) (FLOAT bits))
   )
   :pattern ((has_type (I x) (FLOAT bits)))
   :qid prelude_has_type_sint
   :skolemid skolem_prelude_has_type_sint
)))
(assert
 (forall ((x Int)) (!
   (=>
    (charInv x)
    (has_type (I x) CHAR)
   )
   :pattern ((has_type (I x) CHAR))
   :qid prelude_has_type_char
   :skolemid skolem_prelude_has_type_char
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x NAT)
    (<= 0 (%I x))
   )
   :pattern ((has_type x NAT))
   :qid prelude_unbox_int
   :skolemid skolem_prelude_unbox_int
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x USIZE)
    (uInv SZ (%I x))
   )
   :pattern ((has_type x USIZE))
   :qid prelude_unbox_usize
   :skolemid skolem_prelude_unbox_usize
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ISIZE)
    (iInv SZ (%I x))
   )
   :pattern ((has_type x ISIZE))
   :qid prelude_unbox_isize
   :skolemid skolem_prelude_unbox_isize
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (UINT bits))
    (uInv bits (%I x))
   )
   :pattern ((has_type x (UINT bits)))
   :qid prelude_unbox_uint
   :skolemid skolem_prelude_unbox_uint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (SINT bits))
    (iInv bits (%I x))
   )
   :pattern ((has_type x (SINT bits)))
   :qid prelude_unbox_sint
   :skolemid skolem_prelude_unbox_sint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (FLOAT bits))
    (uInv bits (%I x))
   )
   :pattern ((has_type x (FLOAT bits)))
   :qid prelude_unbox_sint
   :skolemid skolem_prelude_unbox_sint
)))
(declare-fun Add (Int Int) Int)
(declare-fun Sub (Int Int) Int)
(declare-fun Mul (Int Int) Int)
(declare-fun EucDiv (Int Int) Int)
(declare-fun EucMod (Int Int) Int)
(declare-fun RAdd (Real Real) Real)
(declare-fun RSub (Real Real) Real)
(declare-fun RMul (Real Real) Real)
(declare-fun RDiv (Real Real) Real)
(assert
 (forall ((x Int) (y Int)) (!
   (= (Add x y) (+ x y))
   :pattern ((Add x y))
   :qid prelude_add
   :skolemid skolem_prelude_add
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (Sub x y) (- x y))
   :pattern ((Sub x y))
   :qid prelude_sub
   :skolemid skolem_prelude_sub
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (Mul x y) (* x y))
   :pattern ((Mul x y))
   :qid prelude_mul
   :skolemid skolem_prelude_mul
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (EucDiv x y) (div x y))
   :pattern ((EucDiv x y))
   :qid prelude_eucdiv
   :skolemid skolem_prelude_eucdiv
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (EucMod x y) (mod x y))
   :pattern ((EucMod x y))
   :qid prelude_eucmod
   :skolemid skolem_prelude_eucmod
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RAdd x y) (+ x y))
   :pattern ((RAdd x y))
   :qid prelude_radd
   :skolemid skolem_prelude_radd
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RSub x y) (- x y))
   :pattern ((RSub x y))
   :qid prelude_rsub
   :skolemid skolem_prelude_rsub
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RMul x y) (* x y))
   :pattern ((RMul x y))
   :qid prelude_rmul
   :skolemid skolem_prelude_rmul
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RDiv x y) (/ x y))
   :pattern ((RDiv x y))
   :qid prelude_rdiv
   :skolemid skolem_prelude_rdiv
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (<= 0 y)
    )
    (<= 0 (Mul x y))
   )
   :pattern ((Mul x y))
   :qid prelude_mul_nats
   :skolemid skolem_prelude_mul_nats
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (< 0 y)
    )
    (and
     (<= 0 (EucDiv x y))
     (<= (EucDiv x y) x)
   ))
   :pattern ((EucDiv x y))
   :qid prelude_div_unsigned_in_bounds
   :skolemid skolem_prelude_div_unsigned_in_bounds
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (< 0 y)
    )
    (and
     (<= 0 (EucMod x y))
     (< (EucMod x y) y)
   ))
   :pattern ((EucMod x y))
   :qid prelude_mod_unsigned_in_bounds
   :skolemid skolem_prelude_mod_unsigned_in_bounds
)))
(declare-fun bitxor (Poly Poly) Int)
(declare-fun bitand (Poly Poly) Int)
(declare-fun bitor (Poly Poly) Int)
(declare-fun bitshr (Poly Poly) Int)
(declare-fun bitshl (Poly Poly) Int)
(declare-fun bitnot (Poly) Int)
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitxor x y))
   )
   :pattern ((uClip bits (bitxor x y)))
   :qid prelude_bit_xor_u_inv
   :skolemid skolem_prelude_bit_xor_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitxor x y))
   )
   :pattern ((iClip bits (bitxor x y)))
   :qid prelude_bit_xor_i_inv
   :skolemid skolem_prelude_bit_xor_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitor x y))
   )
   :pattern ((uClip bits (bitor x y)))
   :qid prelude_bit_or_u_inv
   :skolemid skolem_prelude_bit_or_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitor x y))
   )
   :pattern ((iClip bits (bitor x y)))
   :qid prelude_bit_or_i_inv
   :skolemid skolem_prelude_bit_or_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitand x y))
   )
   :pattern ((uClip bits (bitand x y)))
   :qid prelude_bit_and_u_inv
   :skolemid skolem_prelude_bit_and_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitand x y))
   )
   :pattern ((iClip bits (bitand x y)))
   :qid prelude_bit_and_i_inv
   :skolemid skolem_prelude_bit_and_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (<= 0 (%I y))
    )
    (uInv bits (bitshr x y))
   )
   :pattern ((uClip bits (bitshr x y)))
   :qid prelude_bit_shr_u_inv
   :skolemid skolem_prelude_bit_shr_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (<= 0 (%I y))
    )
    (iInv bits (bitshr x y))
   )
   :pattern ((iClip bits (bitshr x y)))
   :qid prelude_bit_shr_i_inv
   :skolemid skolem_prelude_bit_shr_i_inv
)))
(declare-fun singular_mod (Int Int) Int)
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (not (= y 0))
    (= (EucMod x y) (singular_mod x y))
   )
   :pattern ((singular_mod x y))
   :qid prelude_singularmod
   :skolemid skolem_prelude_singularmod
)))
(declare-fun has_resolved (Dcr Type Poly) Bool)
(declare-fun closure_req (Type Dcr Type Poly Poly) Bool)
(declare-fun closure_ens (Type Dcr Type Poly Poly Poly) Bool)
(declare-fun default_ens (Type Dcr Type Poly Poly Poly) Bool)
(declare-fun height (Poly) Height)
(declare-fun height_lt (Height Height) Bool)
(declare-fun fun_from_recursive_field (Poly) Poly)
(declare-fun check_decrease_int (Int Int Bool) Bool)
(assert
 (forall ((cur Int) (prev Int) (otherwise Bool)) (!
   (= (check_decrease_int cur prev otherwise) (or
     (and
      (<= 0 cur)
      (< cur prev)
     )
     (and
      (= cur prev)
      otherwise
   )))
   :pattern ((check_decrease_int cur prev otherwise))
   :qid prelude_check_decrease_int
   :skolemid skolem_prelude_check_decrease_int
)))
(declare-fun check_decrease_height (Poly Poly Bool) Bool)
(assert
 (forall ((cur Poly) (prev Poly) (otherwise Bool)) (!
   (= (check_decrease_height cur prev otherwise) (or
     (height_lt (height cur) (height prev))
     (and
      (= (height cur) (height prev))
      otherwise
   )))
   :pattern ((check_decrease_height cur prev otherwise))
   :qid prelude_check_decrease_height
   :skolemid skolem_prelude_check_decrease_height
)))
(assert
 (forall ((x Height) (y Height)) (!
   (= (height_lt x y) (and
     ((_ partial-order 0) x y)
     (not (= x y))
   ))
   :pattern ((height_lt x y))
   :qid prelude_height_lt
   :skolemid skolem_prelude_height_lt
)))

;; MODULE 'module window'
;; curve25519-dalek/src/window.rs:414:5: 414:63 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!std_specs.convert.impl&%6.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%6.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%7.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%7.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%8.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%8.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%9.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%9.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%11.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%11.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%12.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%12.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%13.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%13.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%15.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%15.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.core.iter_into_iter_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%31.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%31.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%32.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%32.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%33.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%33.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%33.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%34.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%34.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%34.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%35.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%35.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%38.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%38.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%38.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%39.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%39.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%39.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%40.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%40.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.option.impl&%0.arrow_0. FuelId)
(declare-const fuel%vstd!std_specs.option.is_some. FuelId)
(declare-const fuel%vstd!std_specs.option.is_none. FuelId)
(declare-const fuel%vstd!std_specs.option.spec_unwrap. FuelId)
(declare-const fuel%vstd!std_specs.option.spec_unwrap_or. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%3.ghost_iter. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.exec_invariant. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.ghost_invariant. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.ghost_ensures. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.ghost_decrease. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.ghost_peek_next. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.ghost_advance. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%5.view. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%6.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%6.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%6.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%6.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_u8. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%7.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%7.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%7.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%7.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_u16. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%8.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%8.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%8.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%8.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_u32. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%9.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%9.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%9.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%9.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_u64. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%11.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%11.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%11.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%11.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_usize. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%12.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%12.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%12.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%12.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_i8. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%13.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%13.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%13.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%13.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_i16. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%14.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%14.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%14.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%14.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_i32. FuelId)
(declare-const fuel%vstd!std_specs.slice.impl&%1.spec_index_set_requires. FuelId)
(declare-const fuel%vstd!std_specs.slice.impl&%1.spec_index_set_ensures. FuelId)
(declare-const fuel%vstd!std_specs.slice.impl&%3.spec_index_set_requires. FuelId)
(declare-const fuel%vstd!std_specs.slice.impl&%3.spec_index_set_ensures. FuelId)
(declare-const fuel%vstd!array.array_view. FuelId)
(declare-const fuel%vstd!array.impl&%0.view. FuelId)
(declare-const fuel%vstd!array.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!array.lemma_array_index. FuelId)
(declare-const fuel%vstd!array.array_len_matches_n. FuelId)
(declare-const fuel%vstd!array.axiom_spec_array_as_slice. FuelId)
(declare-const fuel%vstd!array.axiom_spec_array_fill_for_copy_type. FuelId)
(declare-const fuel%vstd!array.axiom_array_ext_equal. FuelId)
(declare-const fuel%vstd!array.axiom_array_has_resolved. FuelId)
(declare-const fuel%vstd!pervasive.impl&%0.ensures. FuelId)
(declare-const fuel%vstd!pervasive.strictly_cloned. FuelId)
(declare-const fuel%vstd!pervasive.cloned. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%3.view. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq_sized. FuelId)
(declare-const fuel%vstd!seq.impl&%0.spec_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_index_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_update_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_update_same. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_update_different. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal_deep. FuelId)
(declare-const fuel%vstd!slice.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!slice.axiom_spec_len. FuelId)
(declare-const fuel%vstd!slice.axiom_slice_ext_equal. FuelId)
(declare-const fuel%vstd!slice.axiom_slice_has_resolved. FuelId)
(declare-const fuel%vstd!string.axiom_str_literal_len. FuelId)
(declare-const fuel%vstd!string.axiom_str_literal_get_char. FuelId)
(declare-const fuel%vstd!view.impl&%0.view. FuelId)
(declare-const fuel%vstd!view.impl&%2.view. FuelId)
(declare-const fuel%vstd!view.impl&%4.view. FuelId)
(declare-const fuel%vstd!view.impl&%6.view. FuelId)
(declare-const fuel%vstd!view.impl&%10.view. FuelId)
(declare-const fuel%vstd!view.impl&%12.view. FuelId)
(declare-const fuel%vstd!view.impl&%14.view. FuelId)
(declare-const fuel%vstd!view.impl&%16.view. FuelId)
(declare-const fuel%vstd!view.impl&%18.view. FuelId)
(declare-const fuel%vstd!view.impl&%20.view. FuelId)
(declare-const fuel%vstd!view.impl&%22.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%vstd!view.impl&%28.view. FuelId)
(declare-const fuel%vstd!view.impl&%30.view. FuelId)
(declare-const fuel%vstd!view.impl&%32.view. FuelId)
(declare-const fuel%vstd!view.impl&%40.view. FuelId)
(declare-const fuel%vstd!view.impl&%42.view. FuelId)
(declare-const fuel%vstd!view.impl&%44.view. FuelId)
(declare-const fuel%vstd!view.impl&%48.view. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.obeys_add_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_req.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.obeys_add_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_req.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_identity. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.identity_affine_niels. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.identity_projective_niels.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.negate_affine_niels. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.negate_projective_niels.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_double. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_completed_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.completed_to_extended. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.u64_5_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_sub. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_mul. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_square. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_inv. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.p. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.field_canonical. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.mask51. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.spec_negate. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.naf_lookup_table8_projective_limbs_bounded.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.naf_lookup_table8_affine_limbs_bounded.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_projective.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_affine.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%0.obeys_from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%0.from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%1.obeys_from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%1.from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%2.obeys_from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%2.from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%3.obeys_from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%3.from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%4.obeys_from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%4.from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%5.obeys_from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%5.from_spec. FuelId)
(declare-const fuel%curve25519_dalek!edwards.impl&%15.well_formed. FuelId)
(declare-const fuel%curve25519_dalek!edwards.impl&%31.obeys_add_spec. FuelId)
(declare-const fuel%curve25519_dalek!edwards.impl&%31.add_req. FuelId)
(declare-const fuel%curve25519_dalek!edwards.impl&%31.add_spec. FuelId)
(declare-const fuel%vstd!array.group_array_axioms. FuelId)
(declare-const fuel%vstd!function.group_function_axioms. FuelId)
(declare-const fuel%vstd!laws_cmp.group_laws_cmp. FuelId)
(declare-const fuel%vstd!laws_eq.bool_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u8_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i8_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u16_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i16_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u32_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i32_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u64_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i64_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u128_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i128_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.usize_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.isize_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.group_laws_eq. FuelId)
(declare-const fuel%vstd!layout.group_layout_axioms. FuelId)
(declare-const fuel%vstd!map.group_map_axioms. FuelId)
(declare-const fuel%vstd!multiset.group_multiset_axioms. FuelId)
(declare-const fuel%vstd!raw_ptr.group_raw_ptr_axioms. FuelId)
(declare-const fuel%vstd!seq.group_seq_axioms. FuelId)
(declare-const fuel%vstd!seq_lib.group_filter_ensures. FuelId)
(declare-const fuel%vstd!seq_lib.group_seq_lib_default. FuelId)
(declare-const fuel%vstd!set.group_set_axioms. FuelId)
(declare-const fuel%vstd!set_lib.group_set_lib_default. FuelId)
(declare-const fuel%vstd!slice.group_slice_axioms. FuelId)
(declare-const fuel%vstd!string.group_string_axioms. FuelId)
(declare-const fuel%vstd!std_specs.bits.group_bits_axioms. FuelId)
(declare-const fuel%vstd!std_specs.control_flow.group_control_flow_axioms. FuelId)
(declare-const fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms. FuelId)
(declare-const fuel%vstd!std_specs.hash.group_hash_axioms. FuelId)
(declare-const fuel%vstd!std_specs.range.group_range_axioms. FuelId)
(declare-const fuel%vstd!std_specs.slice.group_slice_axioms. FuelId)
(declare-const fuel%vstd!std_specs.vec.group_vec_axioms. FuelId)
(declare-const fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms. FuelId)
(declare-const fuel%vstd!group_vstd_default. FuelId)
(assert
 (distinct fuel%vstd!std_specs.convert.impl&%6.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%6.from_spec.
  fuel%vstd!std_specs.convert.impl&%7.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%7.from_spec.
  fuel%vstd!std_specs.convert.impl&%8.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%8.from_spec.
  fuel%vstd!std_specs.convert.impl&%9.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%9.from_spec.
  fuel%vstd!std_specs.convert.impl&%11.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%11.from_spec.
  fuel%vstd!std_specs.convert.impl&%12.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%12.from_spec.
  fuel%vstd!std_specs.convert.impl&%13.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%13.from_spec.
  fuel%vstd!std_specs.convert.impl&%15.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%15.from_spec.
  fuel%vstd!std_specs.core.iter_into_iter_spec. fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec.
  fuel%vstd!std_specs.ops.impl&%31.add_req. fuel%vstd!std_specs.ops.impl&%31.add_spec.
  fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec. fuel%vstd!std_specs.ops.impl&%32.add_req.
  fuel%vstd!std_specs.ops.impl&%32.add_spec. fuel%vstd!std_specs.ops.impl&%33.obeys_add_spec.
  fuel%vstd!std_specs.ops.impl&%33.add_req. fuel%vstd!std_specs.ops.impl&%33.add_spec.
  fuel%vstd!std_specs.ops.impl&%34.obeys_add_spec. fuel%vstd!std_specs.ops.impl&%34.add_req.
  fuel%vstd!std_specs.ops.impl&%34.add_spec. fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec.
  fuel%vstd!std_specs.ops.impl&%35.add_req. fuel%vstd!std_specs.ops.impl&%35.add_spec.
  fuel%vstd!std_specs.ops.impl&%38.obeys_add_spec. fuel%vstd!std_specs.ops.impl&%38.add_req.
  fuel%vstd!std_specs.ops.impl&%38.add_spec. fuel%vstd!std_specs.ops.impl&%39.obeys_add_spec.
  fuel%vstd!std_specs.ops.impl&%39.add_req. fuel%vstd!std_specs.ops.impl&%39.add_spec.
  fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec. fuel%vstd!std_specs.ops.impl&%40.add_req.
  fuel%vstd!std_specs.ops.impl&%40.add_spec. fuel%vstd!std_specs.option.impl&%0.arrow_0.
  fuel%vstd!std_specs.option.is_some. fuel%vstd!std_specs.option.is_none. fuel%vstd!std_specs.option.spec_unwrap.
  fuel%vstd!std_specs.option.spec_unwrap_or. fuel%vstd!std_specs.range.impl&%3.ghost_iter.
  fuel%vstd!std_specs.range.impl&%4.exec_invariant. fuel%vstd!std_specs.range.impl&%4.ghost_invariant.
  fuel%vstd!std_specs.range.impl&%4.ghost_ensures. fuel%vstd!std_specs.range.impl&%4.ghost_decrease.
  fuel%vstd!std_specs.range.impl&%4.ghost_peek_next. fuel%vstd!std_specs.range.impl&%4.ghost_advance.
  fuel%vstd!std_specs.range.impl&%5.view. fuel%vstd!std_specs.range.impl&%6.spec_is_lt.
  fuel%vstd!std_specs.range.impl&%6.spec_steps_between_int. fuel%vstd!std_specs.range.impl&%6.spec_forward_checked.
  fuel%vstd!std_specs.range.impl&%6.spec_forward_checked_int. fuel%vstd!std_specs.range.axiom_spec_range_next_u8.
  fuel%vstd!std_specs.range.impl&%7.spec_is_lt. fuel%vstd!std_specs.range.impl&%7.spec_steps_between_int.
  fuel%vstd!std_specs.range.impl&%7.spec_forward_checked. fuel%vstd!std_specs.range.impl&%7.spec_forward_checked_int.
  fuel%vstd!std_specs.range.axiom_spec_range_next_u16. fuel%vstd!std_specs.range.impl&%8.spec_is_lt.
  fuel%vstd!std_specs.range.impl&%8.spec_steps_between_int. fuel%vstd!std_specs.range.impl&%8.spec_forward_checked.
  fuel%vstd!std_specs.range.impl&%8.spec_forward_checked_int. fuel%vstd!std_specs.range.axiom_spec_range_next_u32.
  fuel%vstd!std_specs.range.impl&%9.spec_is_lt. fuel%vstd!std_specs.range.impl&%9.spec_steps_between_int.
  fuel%vstd!std_specs.range.impl&%9.spec_forward_checked. fuel%vstd!std_specs.range.impl&%9.spec_forward_checked_int.
  fuel%vstd!std_specs.range.axiom_spec_range_next_u64. fuel%vstd!std_specs.range.impl&%11.spec_is_lt.
  fuel%vstd!std_specs.range.impl&%11.spec_steps_between_int. fuel%vstd!std_specs.range.impl&%11.spec_forward_checked.
  fuel%vstd!std_specs.range.impl&%11.spec_forward_checked_int. fuel%vstd!std_specs.range.axiom_spec_range_next_usize.
  fuel%vstd!std_specs.range.impl&%12.spec_is_lt. fuel%vstd!std_specs.range.impl&%12.spec_steps_between_int.
  fuel%vstd!std_specs.range.impl&%12.spec_forward_checked. fuel%vstd!std_specs.range.impl&%12.spec_forward_checked_int.
  fuel%vstd!std_specs.range.axiom_spec_range_next_i8. fuel%vstd!std_specs.range.impl&%13.spec_is_lt.
  fuel%vstd!std_specs.range.impl&%13.spec_steps_between_int. fuel%vstd!std_specs.range.impl&%13.spec_forward_checked.
  fuel%vstd!std_specs.range.impl&%13.spec_forward_checked_int. fuel%vstd!std_specs.range.axiom_spec_range_next_i16.
  fuel%vstd!std_specs.range.impl&%14.spec_is_lt. fuel%vstd!std_specs.range.impl&%14.spec_steps_between_int.
  fuel%vstd!std_specs.range.impl&%14.spec_forward_checked. fuel%vstd!std_specs.range.impl&%14.spec_forward_checked_int.
  fuel%vstd!std_specs.range.axiom_spec_range_next_i32. fuel%vstd!std_specs.slice.impl&%1.spec_index_set_requires.
  fuel%vstd!std_specs.slice.impl&%1.spec_index_set_ensures. fuel%vstd!std_specs.slice.impl&%3.spec_index_set_requires.
  fuel%vstd!std_specs.slice.impl&%3.spec_index_set_ensures. fuel%vstd!array.array_view.
  fuel%vstd!array.impl&%0.view. fuel%vstd!array.impl&%2.spec_index. fuel%vstd!array.lemma_array_index.
  fuel%vstd!array.array_len_matches_n. fuel%vstd!array.axiom_spec_array_as_slice. fuel%vstd!array.axiom_spec_array_fill_for_copy_type.
  fuel%vstd!array.axiom_array_ext_equal. fuel%vstd!array.axiom_array_has_resolved.
  fuel%vstd!pervasive.impl&%0.ensures. fuel%vstd!pervasive.strictly_cloned. fuel%vstd!pervasive.cloned.
  fuel%vstd!raw_ptr.impl&%3.view. fuel%vstd!raw_ptr.ptrs_mut_eq. fuel%vstd!raw_ptr.ptrs_mut_eq_sized.
  fuel%vstd!seq.impl&%0.spec_index. fuel%vstd!seq.axiom_seq_index_decreases. fuel%vstd!seq.axiom_seq_new_len.
  fuel%vstd!seq.axiom_seq_new_index. fuel%vstd!seq.axiom_seq_update_len. fuel%vstd!seq.axiom_seq_update_same.
  fuel%vstd!seq.axiom_seq_update_different. fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep.
  fuel%vstd!slice.impl&%2.spec_index. fuel%vstd!slice.axiom_spec_len. fuel%vstd!slice.axiom_slice_ext_equal.
  fuel%vstd!slice.axiom_slice_has_resolved. fuel%vstd!string.axiom_str_literal_len.
  fuel%vstd!string.axiom_str_literal_get_char. fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view.
  fuel%vstd!view.impl&%4.view. fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%10.view.
  fuel%vstd!view.impl&%12.view. fuel%vstd!view.impl&%14.view. fuel%vstd!view.impl&%16.view.
  fuel%vstd!view.impl&%18.view. fuel%vstd!view.impl&%20.view. fuel%vstd!view.impl&%22.view.
  fuel%vstd!view.impl&%26.view. fuel%vstd!view.impl&%28.view. fuel%vstd!view.impl&%30.view.
  fuel%vstd!view.impl&%32.view. fuel%vstd!view.impl&%40.view. fuel%vstd!view.impl&%42.view.
  fuel%vstd!view.impl&%44.view. fuel%vstd!view.impl&%48.view. fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req. fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec.
  fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D. fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
  fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.obeys_add_spec. fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_req.
  fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_spec. fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.obeys_add_spec.
  fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_req. fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_spec.
  fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve. fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_identity. fuel%curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.
  fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point. fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded. fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded. fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine. fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_nat.
  fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards. fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.
  fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point. fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.
  fuel%curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards. fuel%curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.
  fuel%curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards. fuel%curve25519_dalek!specs.edwards_specs.identity_affine_niels.
  fuel%curve25519_dalek!specs.edwards_specs.identity_projective_niels. fuel%curve25519_dalek!specs.edwards_specs.negate_affine_niels.
  fuel%curve25519_dalek!specs.edwards_specs.negate_projective_niels. fuel%curve25519_dalek!specs.edwards_specs.edwards_add.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_double. fuel%curve25519_dalek!specs.edwards_specs.is_valid_completed_point.
  fuel%curve25519_dalek!specs.edwards_specs.completed_to_extended. fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.
  fuel%curve25519_dalek!specs.field_specs.u64_5_bounded. fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded.
  fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded. fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.
  fuel%curve25519_dalek!specs.field_specs.fe51_as_nat. fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.
  fuel%curve25519_dalek!specs.field_specs.field_add. fuel%curve25519_dalek!specs.field_specs.field_sub.
  fuel%curve25519_dalek!specs.field_specs.field_mul. fuel%curve25519_dalek!specs.field_specs.field_square.
  fuel%curve25519_dalek!specs.field_specs.field_inv. fuel%curve25519_dalek!specs.field_specs_u64.p.
  fuel%curve25519_dalek!specs.field_specs_u64.field_canonical. fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.
  fuel%curve25519_dalek!specs.field_specs_u64.mask51. fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.
  fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce. fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.
  fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs. fuel%curve25519_dalek!specs.field_specs_u64.spec_negate.
  fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective. fuel%curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.
  fuel%curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded. fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.
  fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine. fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.
  fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.
  fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective. fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.
  fuel%curve25519_dalek!specs.window_specs.naf_lookup_table8_projective_limbs_bounded.
  fuel%curve25519_dalek!specs.window_specs.naf_lookup_table8_affine_limbs_bounded.
  fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_projective. fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_affine.
  fuel%curve25519_dalek!specs.window_specs.impl&%0.obeys_from_spec. fuel%curve25519_dalek!specs.window_specs.impl&%0.from_spec.
  fuel%curve25519_dalek!specs.window_specs.impl&%1.obeys_from_spec. fuel%curve25519_dalek!specs.window_specs.impl&%1.from_spec.
  fuel%curve25519_dalek!specs.window_specs.impl&%2.obeys_from_spec. fuel%curve25519_dalek!specs.window_specs.impl&%2.from_spec.
  fuel%curve25519_dalek!specs.window_specs.impl&%3.obeys_from_spec. fuel%curve25519_dalek!specs.window_specs.impl&%3.from_spec.
  fuel%curve25519_dalek!specs.window_specs.impl&%4.obeys_from_spec. fuel%curve25519_dalek!specs.window_specs.impl&%4.from_spec.
  fuel%curve25519_dalek!specs.window_specs.impl&%5.obeys_from_spec. fuel%curve25519_dalek!specs.window_specs.impl&%5.from_spec.
  fuel%curve25519_dalek!edwards.impl&%15.well_formed. fuel%curve25519_dalek!edwards.impl&%31.obeys_add_spec.
  fuel%curve25519_dalek!edwards.impl&%31.add_req. fuel%curve25519_dalek!edwards.impl&%31.add_spec.
  fuel%vstd!array.group_array_axioms. fuel%vstd!function.group_function_axioms. fuel%vstd!laws_cmp.group_laws_cmp.
  fuel%vstd!laws_eq.bool_laws.group_laws_eq. fuel%vstd!laws_eq.u8_laws.group_laws_eq.
  fuel%vstd!laws_eq.i8_laws.group_laws_eq. fuel%vstd!laws_eq.u16_laws.group_laws_eq.
  fuel%vstd!laws_eq.i16_laws.group_laws_eq. fuel%vstd!laws_eq.u32_laws.group_laws_eq.
  fuel%vstd!laws_eq.i32_laws.group_laws_eq. fuel%vstd!laws_eq.u64_laws.group_laws_eq.
  fuel%vstd!laws_eq.i64_laws.group_laws_eq. fuel%vstd!laws_eq.u128_laws.group_laws_eq.
  fuel%vstd!laws_eq.i128_laws.group_laws_eq. fuel%vstd!laws_eq.usize_laws.group_laws_eq.
  fuel%vstd!laws_eq.isize_laws.group_laws_eq. fuel%vstd!laws_eq.group_laws_eq. fuel%vstd!layout.group_layout_axioms.
  fuel%vstd!map.group_map_axioms. fuel%vstd!multiset.group_multiset_axioms. fuel%vstd!raw_ptr.group_raw_ptr_axioms.
  fuel%vstd!seq.group_seq_axioms. fuel%vstd!seq_lib.group_filter_ensures. fuel%vstd!seq_lib.group_seq_lib_default.
  fuel%vstd!set.group_set_axioms. fuel%vstd!set_lib.group_set_lib_default. fuel%vstd!slice.group_slice_axioms.
  fuel%vstd!string.group_string_axioms. fuel%vstd!std_specs.bits.group_bits_axioms.
  fuel%vstd!std_specs.control_flow.group_control_flow_axioms. fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms.
  fuel%vstd!std_specs.hash.group_hash_axioms. fuel%vstd!std_specs.range.group_range_axioms.
  fuel%vstd!std_specs.slice.group_slice_axioms. fuel%vstd!std_specs.vec.group_vec_axioms.
  fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms. fuel%vstd!group_vstd_default.
))
(assert
 (=>
  (fuel_bool_default fuel%vstd!array.group_array_axioms.)
  (and
   (fuel_bool_default fuel%vstd!array.array_len_matches_n.)
   (fuel_bool_default fuel%vstd!array.lemma_array_index.)
   (fuel_bool_default fuel%vstd!array.axiom_spec_array_as_slice.)
   (fuel_bool_default fuel%vstd!array.axiom_spec_array_fill_for_copy_type.)
   (fuel_bool_default fuel%vstd!array.axiom_array_ext_equal.)
   (fuel_bool_default fuel%vstd!array.axiom_array_has_resolved.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!laws_eq.group_laws_eq.)
  (and
   (fuel_bool_default fuel%vstd!laws_eq.bool_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u8_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i8_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u16_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i16_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u32_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i32_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u64_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i64_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u128_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i128_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.usize_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.isize_laws.group_laws_eq.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!raw_ptr.group_raw_ptr_axioms.)
  (and
   (fuel_bool_default fuel%vstd!raw_ptr.ptrs_mut_eq.)
   (fuel_bool_default fuel%vstd!raw_ptr.ptrs_mut_eq_sized.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!seq.group_seq_axioms.)
  (and
   (fuel_bool_default fuel%vstd!seq.axiom_seq_index_decreases.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_index.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_update_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_update_same.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_update_different.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal_deep.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!seq_lib.group_seq_lib_default.)
  (fuel_bool_default fuel%vstd!seq_lib.group_filter_ensures.)
))
(assert
 (=>
  (fuel_bool_default fuel%vstd!slice.group_slice_axioms.)
  (and
   (fuel_bool_default fuel%vstd!slice.axiom_spec_len.)
   (fuel_bool_default fuel%vstd!slice.axiom_slice_ext_equal.)
   (fuel_bool_default fuel%vstd!slice.axiom_slice_has_resolved.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!string.group_string_axioms.)
  (and
   (fuel_bool_default fuel%vstd!string.axiom_str_literal_len.)
   (fuel_bool_default fuel%vstd!string.axiom_str_literal_get_char.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!std_specs.range.group_range_axioms.)
  (and
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_u8.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_u16.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_u32.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_u64.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_usize.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_i8.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_i16.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_i32.)
)))
(assert
 (fuel_bool_default fuel%vstd!group_vstd_default.)
)
(assert
 (=>
  (fuel_bool_default fuel%vstd!group_vstd_default.)
  (and
   (fuel_bool_default fuel%vstd!seq.group_seq_axioms.)
   (fuel_bool_default fuel%vstd!seq_lib.group_seq_lib_default.)
   (fuel_bool_default fuel%vstd!map.group_map_axioms.)
   (fuel_bool_default fuel%vstd!set.group_set_axioms.)
   (fuel_bool_default fuel%vstd!set_lib.group_set_lib_default.)
   (fuel_bool_default fuel%vstd!multiset.group_multiset_axioms.)
   (fuel_bool_default fuel%vstd!function.group_function_axioms.)
   (fuel_bool_default fuel%vstd!laws_eq.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_cmp.group_laws_cmp.)
   (fuel_bool_default fuel%vstd!slice.group_slice_axioms.)
   (fuel_bool_default fuel%vstd!array.group_array_axioms.)
   (fuel_bool_default fuel%vstd!string.group_string_axioms.)
   (fuel_bool_default fuel%vstd!raw_ptr.group_raw_ptr_axioms.)
   (fuel_bool_default fuel%vstd!layout.group_layout_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.range.group_range_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.bits.group_bits_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.control_flow.group_control_flow_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.slice.group_slice_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.vec.group_vec_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.hash.group_hash_axioms.)
)))

;; Trait-Decls
(declare-fun tr_bound%vstd!array.ArrayAdditionalSpecFns. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!pervasive.ForLoopGhostIterator. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!pervasive.ForLoopGhostIteratorNew. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!pervasive.FnWithRequiresEnsures. (Dcr Type Dcr Type Dcr
  Type
 ) Bool
)
(declare-fun tr_bound%vstd!slice.SliceAdditionalSpecFns. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!slice.index.SliceIndex. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!view.View. (Dcr Type) Bool)
(declare-fun tr_bound%core!clone.Clone. (Dcr Type) Bool)
(declare-fun tr_bound%core!cmp.PartialEq. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!cmp.PartialOrd. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!convert.From. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.convert.FromSpec. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!ops.index.Index. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!ops.index.IndexMut. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!alloc.Allocator. (Dcr Type) Bool)
(declare-fun tr_bound%core!fmt.Debug. (Dcr Type) Bool)
(declare-fun tr_bound%core!iter.traits.iterator.Iterator. (Dcr Type) Bool)
(declare-fun tr_bound%core!iter.range.Step. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.core.TrustedSpecSealed. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. (Dcr Type Dcr Type)
 Bool
)
(declare-fun tr_bound%core!default.Default. (Dcr Type) Bool)
(declare-fun tr_bound%core!ops.arith.Add. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.ops.AddSpec. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.option.OptionAdditionalFns. (Dcr Type Dcr Type)
 Bool
)
(declare-fun tr_bound%vstd!std_specs.range.StepSpec. (Dcr Type) Bool)
(declare-fun tr_bound%curve25519_dalek!traits.Identity. (Dcr Type) Bool)

;; Associated-Type-Decls
(declare-fun proj%%vstd!pervasive.ForLoopGhostIterator./ExecIter (Dcr Type) Dcr)
(declare-fun proj%vstd!pervasive.ForLoopGhostIterator./ExecIter (Dcr Type) Type)
(declare-fun proj%%vstd!pervasive.ForLoopGhostIterator./Item (Dcr Type) Dcr)
(declare-fun proj%vstd!pervasive.ForLoopGhostIterator./Item (Dcr Type) Type)
(declare-fun proj%%vstd!pervasive.ForLoopGhostIterator./Decrease (Dcr Type) Dcr)
(declare-fun proj%vstd!pervasive.ForLoopGhostIterator./Decrease (Dcr Type) Type)
(declare-fun proj%%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter (Dcr Type) Dcr)
(declare-fun proj%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter (Dcr Type) Type)
(declare-fun proj%%core!slice.index.SliceIndex./Output (Dcr Type Dcr Type) Dcr)
(declare-fun proj%core!slice.index.SliceIndex./Output (Dcr Type Dcr Type) Type)
(declare-fun proj%%vstd!view.View./V (Dcr Type) Dcr)
(declare-fun proj%vstd!view.View./V (Dcr Type) Type)
(declare-fun proj%%core!ops.index.Index./Output (Dcr Type Dcr Type) Dcr)
(declare-fun proj%core!ops.index.Index./Output (Dcr Type Dcr Type) Type)
(declare-fun proj%%core!iter.traits.iterator.Iterator./Item (Dcr Type) Dcr)
(declare-fun proj%core!iter.traits.iterator.Iterator./Item (Dcr Type) Type)
(declare-fun proj%%core!ops.arith.Add./Output (Dcr Type Dcr Type) Dcr)
(declare-fun proj%core!ops.arith.Add./Output (Dcr Type Dcr Type) Type)

;; Datatypes
(declare-fun pointee_metadata% (Dcr) Type)
(declare-fun pointee_metadata%% (Dcr) Dcr)
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (= (pointee_metadata% d) TYPE%tuple%0.)
   )
   :pattern ((pointee_metadata% d))
   :qid prelude_project_pointee_metadata_sized
   :skolemid skolem_prelude_project_pointee_metadata_sized
)))
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (= (pointee_metadata%% d) $)
   )
   :pattern ((pointee_metadata%% d))
   :qid prelude_project_pointee_metadata_decoration_sized
   :skolemid skolem_prelude_project_pointee_metadata_decoration_sized
)))
(assert
 (= (pointee_metadata% $slice) USIZE)
)
(assert
 (= (pointee_metadata%% $slice) $)
)
(assert
 (forall ((d Dcr)) (!
   (= (pointee_metadata% (DST d)) (pointee_metadata% d))
   :pattern ((pointee_metadata% (DST d)))
   :qid prelude_project_pointee_metadata_decorate_struct_inherit
   :skolemid skolem_prelude_project_pointee_metadata_decorate_struct_inherit
)))
(assert
 (forall ((d Dcr)) (!
   (= (pointee_metadata%% (DST d)) (pointee_metadata%% d))
   :pattern ((pointee_metadata%% (DST d)))
   :qid prelude_project_pointee_metadata_decoration_decorate_struct_inherit
   :skolemid skolem_prelude_project_pointee_metadata_decoration_decorate_struct_inherit
)))
(declare-sort core!fmt.Error. 0)
(declare-sort core!fmt.Formatter. 0)
(declare-sort subtle!Choice. 0)
(declare-sort vstd!raw_ptr.Provenance. 0)
(declare-sort vstd!seq.Seq<char.>. 0)
(declare-sort slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
 0
)
(declare-sort slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
 0
)
(declare-sort strslice%. 0)
(declare-sort allocator_global%. 0)
(declare-datatypes ((core!option.Option. 0) (core!result.Result. 0) (core!ops.range.Range.
   0
  ) (vstd!std_specs.range.RangeGhostIterator. 0) (vstd!raw_ptr.PtrData. 0) (curve25519_dalek!backend.serial.u64.field.FieldElement51.
   0
  ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. 0) (curve25519_dalek!backend.serial.curve_models.CompletedPoint.
   0
  ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. 0) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   0
  ) (curve25519_dalek!edwards.EdwardsPoint. 0) (curve25519_dalek!window.LookupTable.
   0
  ) (curve25519_dalek!window.NafLookupTable5. 0) (curve25519_dalek!window.NafLookupTable8.
   0
  ) (tuple%0. 0) (tuple%1. 0) (tuple%2. 0) (tuple%4. 0)
 ) (((core!option.Option./None) (core!option.Option./Some (core!option.Option./Some/?0
     Poly
   ))
  ) ((core!result.Result./Ok (core!result.Result./Ok/?0 Poly)) (core!result.Result./Err
    (core!result.Result./Err/?0 Poly)
   )
  ) ((core!ops.range.Range./Range (core!ops.range.Range./Range/?start Poly) (core!ops.range.Range./Range/?end
     Poly
   ))
  ) ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?start
     Poly
    ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?cur Poly) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?end
     Poly
   ))
  ) ((vstd!raw_ptr.PtrData./PtrData (vstd!raw_ptr.PtrData./PtrData/?addr Int) (vstd!raw_ptr.PtrData./PtrData/?provenance
     vstd!raw_ptr.Provenance.
    ) (vstd!raw_ptr.PtrData./PtrData/?metadata Poly)
   )
  ) ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/?limbs
     %%Function%%
   ))
  ) ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
    (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?gcd
     Int
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?x
     Int
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?y
     Int
   ))
  ) ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?Y
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?Z
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?T
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
  ) ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint
    (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?y_plus_x
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?y_minus_x
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?xy2d
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
  ) ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
    (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_plus_X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_minus_X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Z
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?T2d
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
  ) ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Y curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Z curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?T curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   )
  ) ((curve25519_dalek!window.LookupTable./LookupTable (curve25519_dalek!window.LookupTable./LookupTable/?0
     %%Function%%
   ))
  ) ((curve25519_dalek!window.NafLookupTable5./NafLookupTable5 (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/?0
     %%Function%%
   ))
  ) ((curve25519_dalek!window.NafLookupTable8./NafLookupTable8 (curve25519_dalek!window.NafLookupTable8./NafLookupTable8/?0
     %%Function%%
   ))
  ) ((tuple%0./tuple%0)) ((tuple%1./tuple%1 (tuple%1./tuple%1/?0 Poly))) ((tuple%2./tuple%2
    (tuple%2./tuple%2/?0 Poly) (tuple%2./tuple%2/?1 Poly)
   )
  ) ((tuple%4./tuple%4 (tuple%4./tuple%4/?0 Poly) (tuple%4./tuple%4/?1 Poly) (tuple%4./tuple%4/?2
     Poly
    ) (tuple%4./tuple%4/?3 Poly)
))))
(declare-fun core!option.Option./Some/0 (Dcr Type core!option.Option.) Poly)
(declare-fun core!result.Result./Ok/0 (Dcr Type Dcr Type core!result.Result.) Poly)
(declare-fun core!result.Result./Err/0 (Dcr Type Dcr Type core!result.Result.) Poly)
(declare-fun core!ops.range.Range./Range/start (core!ops.range.Range.) Poly)
(declare-fun core!ops.range.Range./Range/end (core!ops.range.Range.) Poly)
(declare-fun vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (vstd!std_specs.range.RangeGhostIterator.)
 Poly
)
(declare-fun vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (vstd!std_specs.range.RangeGhostIterator.)
 Poly
)
(declare-fun vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (vstd!std_specs.range.RangeGhostIterator.)
 Poly
)
(declare-fun vstd!raw_ptr.PtrData./PtrData/addr (vstd!raw_ptr.PtrData.) Int)
(declare-fun vstd!raw_ptr.PtrData./PtrData/provenance (vstd!raw_ptr.PtrData.) vstd!raw_ptr.Provenance.)
(declare-fun vstd!raw_ptr.PtrData./PtrData/metadata (vstd!raw_ptr.PtrData.) Poly)
(declare-fun curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
 (curve25519_dalek!backend.serial.u64.field.FieldElement51.) %%Function%%
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Int
)
(declare-fun curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X
 (curve25519_dalek!backend.serial.curve_models.CompletedPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y
 (curve25519_dalek!backend.serial.curve_models.CompletedPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z
 (curve25519_dalek!backend.serial.curve_models.CompletedPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T
 (curve25519_dalek!backend.serial.curve_models.CompletedPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
 (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
 (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
 (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!window.LookupTable./LookupTable/0 (curve25519_dalek!window.LookupTable.)
 %%Function%%
)
(declare-fun curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (curve25519_dalek!window.NafLookupTable5.)
 %%Function%%
)
(declare-fun curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0 (curve25519_dalek!window.NafLookupTable8.)
 %%Function%%
)
(declare-fun tuple%1./tuple%1/0 (tuple%1.) Poly)
(declare-fun tuple%2./tuple%2/0 (tuple%2.) Poly)
(declare-fun tuple%2./tuple%2/1 (tuple%2.) Poly)
(declare-fun tuple%4./tuple%4/0 (tuple%4.) Poly)
(declare-fun tuple%4./tuple%4/1 (tuple%4.) Poly)
(declare-fun tuple%4./tuple%4/2 (tuple%4.) Poly)
(declare-fun tuple%4./tuple%4/3 (tuple%4.) Poly)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%core!option.Option. (Dcr Type) Type)
(declare-fun TYPE%core!result.Result. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%core!ops.range.Range. (Dcr Type) Type)
(declare-fun TYPE%vstd!std_specs.range.RangeGhostIterator. (Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-const TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. Type)
(declare-const TYPE%subtle!Choice. Type)
(declare-const TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 Type
)
(declare-const TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint. Type)
(declare-const TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
 Type
)
(declare-const TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 Type
)
(declare-const TYPE%curve25519_dalek!edwards.EdwardsPoint. Type)
(declare-const TYPE%core!fmt.Formatter. Type)
(declare-const TYPE%core!fmt.Error. Type)
(declare-fun TYPE%curve25519_dalek!window.LookupTable. (Dcr Type) Type)
(declare-fun TYPE%curve25519_dalek!window.NafLookupTable5. (Dcr Type) Type)
(declare-fun TYPE%curve25519_dalek!window.NafLookupTable8. (Dcr Type) Type)
(declare-fun TYPE%tuple%1. (Dcr Type) Type)
(declare-fun TYPE%tuple%2. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%tuple%4. (Dcr Type Dcr Type Dcr Type Dcr Type) Type)
(declare-fun FNDEF%core!clone.Clone.clone. (Dcr Type) Type)
(declare-fun FNDEF%core!convert.From.from. (Dcr Type Dcr Type) Type)
(declare-fun FNDEF%core!default.Default.default. (Dcr Type) Type)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%array%. (%%Function%%) Poly)
(declare-fun %Poly%array%. (Poly) %%Function%%)
(declare-fun Poly%core!fmt.Error. (core!fmt.Error.) Poly)
(declare-fun %Poly%core!fmt.Error. (Poly) core!fmt.Error.)
(declare-fun Poly%core!fmt.Formatter. (core!fmt.Formatter.) Poly)
(declare-fun %Poly%core!fmt.Formatter. (Poly) core!fmt.Formatter.)
(declare-fun Poly%subtle!Choice. (subtle!Choice.) Poly)
(declare-fun %Poly%subtle!Choice. (Poly) subtle!Choice.)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%vstd!seq.Seq<char.>. (vstd!seq.Seq<char.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<char.>. (Poly) vstd!seq.Seq<char.>.)
(declare-fun Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
 (slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.) Poly
)
(declare-fun %Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
 (Poly) slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
)
(declare-fun Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
 (slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.) Poly
)
(declare-fun %Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
 (Poly) slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
)
(declare-fun Poly%strslice%. (strslice%.) Poly)
(declare-fun %Poly%strslice%. (Poly) strslice%.)
(declare-fun Poly%allocator_global%. (allocator_global%.) Poly)
(declare-fun %Poly%allocator_global%. (Poly) allocator_global%.)
(declare-fun Poly%core!option.Option. (core!option.Option.) Poly)
(declare-fun %Poly%core!option.Option. (Poly) core!option.Option.)
(declare-fun Poly%core!result.Result. (core!result.Result.) Poly)
(declare-fun %Poly%core!result.Result. (Poly) core!result.Result.)
(declare-fun Poly%core!ops.range.Range. (core!ops.range.Range.) Poly)
(declare-fun %Poly%core!ops.range.Range. (Poly) core!ops.range.Range.)
(declare-fun Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!std_specs.range.RangeGhostIterator.)
 Poly
)
(declare-fun %Poly%vstd!std_specs.range.RangeGhostIterator. (Poly) vstd!std_specs.range.RangeGhostIterator.)
(declare-fun Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData.) Poly)
(declare-fun %Poly%vstd!raw_ptr.PtrData. (Poly) vstd!raw_ptr.PtrData.)
(declare-fun Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Poly
)
(declare-fun %Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 (Poly) curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
)
(declare-fun Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. (curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. (Poly)
 curve25519_dalek!backend.serial.curve_models.CompletedPoint.
)
(declare-fun Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (
  curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
 ) Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
 (Poly) curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
)
(declare-fun Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 (Poly) curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
)
(declare-fun Poly%curve25519_dalek!edwards.EdwardsPoint. (curve25519_dalek!edwards.EdwardsPoint.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!edwards.EdwardsPoint. (Poly) curve25519_dalek!edwards.EdwardsPoint.)
(declare-fun Poly%curve25519_dalek!window.LookupTable. (curve25519_dalek!window.LookupTable.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!window.LookupTable. (Poly) curve25519_dalek!window.LookupTable.)
(declare-fun Poly%curve25519_dalek!window.NafLookupTable5. (curve25519_dalek!window.NafLookupTable5.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!window.NafLookupTable5. (Poly) curve25519_dalek!window.NafLookupTable5.)
(declare-fun Poly%curve25519_dalek!window.NafLookupTable8. (curve25519_dalek!window.NafLookupTable8.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!window.NafLookupTable8. (Poly) curve25519_dalek!window.NafLookupTable8.)
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
(declare-fun Poly%tuple%1. (tuple%1.) Poly)
(declare-fun %Poly%tuple%1. (Poly) tuple%1.)
(declare-fun Poly%tuple%2. (tuple%2.) Poly)
(declare-fun %Poly%tuple%2. (Poly) tuple%2.)
(declare-fun Poly%tuple%4. (tuple%4.) Poly)
(declare-fun %Poly%tuple%4. (Poly) tuple%4.)
(assert
 (forall ((x %%Function%%)) (!
   (= x (%Poly%fun%1. (Poly%fun%1. x)))
   :pattern ((Poly%fun%1. x))
   :qid internal_crate__fun__1_box_axiom_definition
   :skolemid skolem_internal_crate__fun__1_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
    (= x (Poly%fun%1. (%Poly%fun%1. x)))
   )
   :pattern ((has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__fun__1_unbox_axiom_definition
   :skolemid skolem_internal_crate__fun__1_unbox_axiom_definition
)))
(declare-fun %%apply%%0 (%%Function%% Poly) Poly)
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x %%Function%%)) (!
   (=>
    (forall ((T%0 Poly)) (!
      (=>
       (has_type T%0 T%0&)
       (has_type (%%apply%%0 x T%0) T%1&)
      )
      :pattern ((has_type (%%apply%%0 x T%0) T%1&))
      :qid internal_crate__fun__1_constructor_inner_definition
      :skolemid skolem_internal_crate__fun__1_constructor_inner_definition
    ))
    (has_type (Poly%fun%1. (mk_fun x)) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
   )
   :pattern ((has_type (Poly%fun%1. (mk_fun x)) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__fun__1_constructor_definition
   :skolemid skolem_internal_crate__fun__1_constructor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%0 Poly) (x %%Function%%))
  (!
   (=>
    (and
     (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type T%0 T%0&)
    )
    (has_type (%%apply%%0 x T%0) T%1&)
   )
   :pattern ((%%apply%%0 x T%0) (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&.
      T%1&
   )))
   :qid internal_crate__fun__1_apply_definition
   :skolemid skolem_internal_crate__fun__1_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%0 Poly) (x %%Function%%))
  (!
   (=>
    (and
     (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type T%0 T%0&)
    )
    (height_lt (height (%%apply%%0 x T%0)) (height (fun_from_recursive_field (Poly%fun%1.
        (mk_fun x)
   )))))
   :pattern ((height (%%apply%%0 x T%0)) (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_crate__fun__1_height_apply_definition
   :skolemid skolem_internal_crate__fun__1_height_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (deep Bool) (x Poly) (y Poly))
  (!
   (=>
    (and
     (has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type y (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (forall ((T%0 Poly)) (!
       (=>
        (has_type T%0 T%0&)
        (ext_eq deep T%1& (%%apply%%0 (%Poly%fun%1. x) T%0) (%%apply%%0 (%Poly%fun%1. y) T%0))
       )
       :pattern ((ext_eq deep T%1& (%%apply%%0 (%Poly%fun%1. x) T%0) (%%apply%%0 (%Poly%fun%1.
           y
          ) T%0
       )))
       :qid internal_crate__fun__1_inner_ext_equal_definition
       :skolemid skolem_internal_crate__fun__1_inner_ext_equal_definition
    )))
    (ext_eq deep (TYPE%fun%1. T%0&. T%0& T%1&. T%1&) x y)
   )
   :pattern ((ext_eq deep (TYPE%fun%1. T%0&. T%0& T%1&. T%1&) x y))
   :qid internal_crate__fun__1_ext_equal_definition
   :skolemid skolem_internal_crate__fun__1_ext_equal_definition
)))
(assert
 (forall ((x %%Function%%)) (!
   (= x (%Poly%array%. (Poly%array%. x)))
   :pattern ((Poly%array%. x))
   :qid internal_crate__array___box_axiom_definition
   :skolemid skolem_internal_crate__array___box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (x Poly)) (!
   (=>
    (has_type x (ARRAY T&. T& N&. N&))
    (= x (Poly%array%. (%Poly%array%. x)))
   )
   :pattern ((has_type x (ARRAY T&. T& N&. N&)))
   :qid internal_crate__array___unbox_axiom_definition
   :skolemid skolem_internal_crate__array___unbox_axiom_definition
)))
(assert
 (forall ((x core!fmt.Error.)) (!
   (= x (%Poly%core!fmt.Error. (Poly%core!fmt.Error. x)))
   :pattern ((Poly%core!fmt.Error. x))
   :qid internal_core__fmt__Error_box_axiom_definition
   :skolemid skolem_internal_core__fmt__Error_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%core!fmt.Error.)
    (= x (Poly%core!fmt.Error. (%Poly%core!fmt.Error. x)))
   )
   :pattern ((has_type x TYPE%core!fmt.Error.))
   :qid internal_core__fmt__Error_unbox_axiom_definition
   :skolemid skolem_internal_core__fmt__Error_unbox_axiom_definition
)))
(assert
 (forall ((x core!fmt.Error.)) (!
   (has_type (Poly%core!fmt.Error. x) TYPE%core!fmt.Error.)
   :pattern ((has_type (Poly%core!fmt.Error. x) TYPE%core!fmt.Error.))
   :qid internal_core__fmt__Error_has_type_always_definition
   :skolemid skolem_internal_core__fmt__Error_has_type_always_definition
)))
(assert
 (forall ((x core!fmt.Formatter.)) (!
   (= x (%Poly%core!fmt.Formatter. (Poly%core!fmt.Formatter. x)))
   :pattern ((Poly%core!fmt.Formatter. x))
   :qid internal_core__fmt__Formatter_box_axiom_definition
   :skolemid skolem_internal_core__fmt__Formatter_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%core!fmt.Formatter.)
    (= x (Poly%core!fmt.Formatter. (%Poly%core!fmt.Formatter. x)))
   )
   :pattern ((has_type x TYPE%core!fmt.Formatter.))
   :qid internal_core__fmt__Formatter_unbox_axiom_definition
   :skolemid skolem_internal_core__fmt__Formatter_unbox_axiom_definition
)))
(assert
 (forall ((x core!fmt.Formatter.)) (!
   (has_type (Poly%core!fmt.Formatter. x) TYPE%core!fmt.Formatter.)
   :pattern ((has_type (Poly%core!fmt.Formatter. x) TYPE%core!fmt.Formatter.))
   :qid internal_core__fmt__Formatter_has_type_always_definition
   :skolemid skolem_internal_core__fmt__Formatter_has_type_always_definition
)))
(assert
 (forall ((x subtle!Choice.)) (!
   (= x (%Poly%subtle!Choice. (Poly%subtle!Choice. x)))
   :pattern ((Poly%subtle!Choice. x))
   :qid internal_subtle__Choice_box_axiom_definition
   :skolemid skolem_internal_subtle__Choice_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%subtle!Choice.)
    (= x (Poly%subtle!Choice. (%Poly%subtle!Choice. x)))
   )
   :pattern ((has_type x TYPE%subtle!Choice.))
   :qid internal_subtle__Choice_unbox_axiom_definition
   :skolemid skolem_internal_subtle__Choice_unbox_axiom_definition
)))
(assert
 (forall ((x subtle!Choice.)) (!
   (has_type (Poly%subtle!Choice. x) TYPE%subtle!Choice.)
   :pattern ((has_type (Poly%subtle!Choice. x) TYPE%subtle!Choice.))
   :qid internal_subtle__Choice_has_type_always_definition
   :skolemid skolem_internal_subtle__Choice_has_type_always_definition
)))
(assert
 (forall ((x vstd!raw_ptr.Provenance.)) (!
   (= x (%Poly%vstd!raw_ptr.Provenance. (Poly%vstd!raw_ptr.Provenance. x)))
   :pattern ((Poly%vstd!raw_ptr.Provenance. x))
   :qid internal_vstd__raw_ptr__Provenance_box_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%vstd!raw_ptr.Provenance.)
    (= x (Poly%vstd!raw_ptr.Provenance. (%Poly%vstd!raw_ptr.Provenance. x)))
   )
   :pattern ((has_type x TYPE%vstd!raw_ptr.Provenance.))
   :qid internal_vstd__raw_ptr__Provenance_unbox_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!raw_ptr.Provenance.)) (!
   (has_type (Poly%vstd!raw_ptr.Provenance. x) TYPE%vstd!raw_ptr.Provenance.)
   :pattern ((has_type (Poly%vstd!raw_ptr.Provenance. x) TYPE%vstd!raw_ptr.Provenance.))
   :qid internal_vstd__raw_ptr__Provenance_has_type_always_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<char.>.)) (!
   (= x (%Poly%vstd!seq.Seq<char.>. (Poly%vstd!seq.Seq<char.>. x)))
   :pattern ((Poly%vstd!seq.Seq<char.>. x))
   :qid internal_vstd__seq__Seq<char.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<char.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ CHAR))
    (= x (Poly%vstd!seq.Seq<char.>. (%Poly%vstd!seq.Seq<char.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ CHAR)))
   :qid internal_vstd__seq__Seq<char.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<char.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<char.>.)) (!
   (has_type (Poly%vstd!seq.Seq<char.>. x) (TYPE%vstd!seq.Seq. $ CHAR))
   :pattern ((has_type (Poly%vstd!seq.Seq<char.>. x) (TYPE%vstd!seq.Seq. $ CHAR)))
   :qid internal_vstd__seq__Seq<char.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<char.>_has_type_always_definition
)))
(assert
 (forall ((x slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.))
  (!
   (= x (%Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
     (Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>. x)
   ))
   :pattern ((Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
     x
   ))
   :qid internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>_box_axiom_definition
   :skolemid skolem_internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
    (= x (Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
      (%Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>. x)
   )))
   :pattern ((has_type x (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)))
   :qid internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>_unbox_axiom_definition
   :skolemid skolem_internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>_unbox_axiom_definition
)))
(assert
 (forall ((x slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.))
  (!
   (has_type (Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
     x
    ) (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
   )
   :pattern ((has_type (Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
      x
     ) (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
   ))
   :qid internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>_has_type_always_definition
   :skolemid skolem_internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>_has_type_always_definition
)))
(assert
 (forall ((x slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.))
  (!
   (= x (%Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
     (Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
      x
   )))
   :pattern ((Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
     x
   ))
   :qid internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>_box_axiom_definition
   :skolemid skolem_internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
    (= x (Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
      (%Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
       x
   ))))
   :pattern ((has_type x (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)))
   :qid internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>_unbox_axiom_definition
   :skolemid skolem_internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>_unbox_axiom_definition
)))
(assert
 (forall ((x slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.))
  (!
   (has_type (Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
     x
    ) (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :pattern ((has_type (Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
      x
     ) (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   ))
   :qid internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>_has_type_always_definition
   :skolemid skolem_internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>_has_type_always_definition
)))
(assert
 (forall ((x strslice%.)) (!
   (= x (%Poly%strslice%. (Poly%strslice%. x)))
   :pattern ((Poly%strslice%. x))
   :qid internal_crate__strslice___box_axiom_definition
   :skolemid skolem_internal_crate__strslice___box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x STRSLICE)
    (= x (Poly%strslice%. (%Poly%strslice%. x)))
   )
   :pattern ((has_type x STRSLICE))
   :qid internal_crate__strslice___unbox_axiom_definition
   :skolemid skolem_internal_crate__strslice___unbox_axiom_definition
)))
(assert
 (forall ((x strslice%.)) (!
   (has_type (Poly%strslice%. x) STRSLICE)
   :pattern ((has_type (Poly%strslice%. x) STRSLICE))
   :qid internal_crate__strslice___has_type_always_definition
   :skolemid skolem_internal_crate__strslice___has_type_always_definition
)))
(assert
 (forall ((x allocator_global%.)) (!
   (= x (%Poly%allocator_global%. (Poly%allocator_global%. x)))
   :pattern ((Poly%allocator_global%. x))
   :qid internal_crate__allocator_global___box_axiom_definition
   :skolemid skolem_internal_crate__allocator_global___box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ALLOCATOR_GLOBAL)
    (= x (Poly%allocator_global%. (%Poly%allocator_global%. x)))
   )
   :pattern ((has_type x ALLOCATOR_GLOBAL))
   :qid internal_crate__allocator_global___unbox_axiom_definition
   :skolemid skolem_internal_crate__allocator_global___unbox_axiom_definition
)))
(assert
 (forall ((x allocator_global%.)) (!
   (has_type (Poly%allocator_global%. x) ALLOCATOR_GLOBAL)
   :pattern ((has_type (Poly%allocator_global%. x) ALLOCATOR_GLOBAL))
   :qid internal_crate__allocator_global___has_type_always_definition
   :skolemid skolem_internal_crate__allocator_global___has_type_always_definition
)))
(assert
 (forall ((x core!option.Option.)) (!
   (= x (%Poly%core!option.Option. (Poly%core!option.Option. x)))
   :pattern ((Poly%core!option.Option. x))
   :qid internal_core__option__Option_box_axiom_definition
   :skolemid skolem_internal_core__option__Option_box_axiom_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!option.Option. V&. V&))
    (= x (Poly%core!option.Option. (%Poly%core!option.Option. x)))
   )
   :pattern ((has_type x (TYPE%core!option.Option. V&. V&)))
   :qid internal_core__option__Option_unbox_axiom_definition
   :skolemid skolem_internal_core__option__Option_unbox_axiom_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type)) (!
   (has_type (Poly%core!option.Option. core!option.Option./None) (TYPE%core!option.Option.
     V&. V&
   ))
   :pattern ((has_type (Poly%core!option.Option. core!option.Option./None) (TYPE%core!option.Option.
      V&. V&
   )))
   :qid internal_core!option.Option./None_constructor_definition
   :skolemid skolem_internal_core!option.Option./None_constructor_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (_0! Poly)) (!
   (=>
    (has_type _0! V&)
    (has_type (Poly%core!option.Option. (core!option.Option./Some _0!)) (TYPE%core!option.Option.
      V&. V&
   )))
   :pattern ((has_type (Poly%core!option.Option. (core!option.Option./Some _0!)) (TYPE%core!option.Option.
      V&. V&
   )))
   :qid internal_core!option.Option./Some_constructor_definition
   :skolemid skolem_internal_core!option.Option./Some_constructor_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x core!option.Option.)) (!
   (=>
    (is-core!option.Option./Some x)
    (= (core!option.Option./Some/0 V&. V& x) (core!option.Option./Some/?0 x))
   )
   :pattern ((core!option.Option./Some/0 V&. V& x))
   :qid internal_core!option.Option./Some/0_accessor_definition
   :skolemid skolem_internal_core!option.Option./Some/0_accessor_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!option.Option. V&. V&))
    (has_type (core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. x)) V&)
   )
   :pattern ((core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. x)) (has_type
     x (TYPE%core!option.Option. V&. V&)
   ))
   :qid internal_core!option.Option./Some/0_invariant_definition
   :skolemid skolem_internal_core!option.Option./Some/0_invariant_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x core!option.Option.)) (!
   (=>
    (is-core!option.Option./Some x)
    (height_lt (height (core!option.Option./Some/0 V&. V& x)) (height (Poly%core!option.Option.
       x
   ))))
   :pattern ((height (core!option.Option./Some/0 V&. V& x)))
   :qid prelude_datatype_height_core!option.Option./Some/0
   :skolemid skolem_prelude_datatype_height_core!option.Option./Some/0
)))
(assert
 (forall ((V&. Dcr) (V& Type) (deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x (TYPE%core!option.Option. V&. V&))
     (has_type y (TYPE%core!option.Option. V&. V&))
     (is-core!option.Option./None (%Poly%core!option.Option. x))
     (is-core!option.Option./None (%Poly%core!option.Option. y))
    )
    (ext_eq deep (TYPE%core!option.Option. V&. V&) x y)
   )
   :pattern ((ext_eq deep (TYPE%core!option.Option. V&. V&) x y))
   :qid internal_core!option.Option./None_ext_equal_definition
   :skolemid skolem_internal_core!option.Option./None_ext_equal_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x (TYPE%core!option.Option. V&. V&))
     (has_type y (TYPE%core!option.Option. V&. V&))
     (is-core!option.Option./Some (%Poly%core!option.Option. x))
     (is-core!option.Option./Some (%Poly%core!option.Option. y))
     (ext_eq deep V& (core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. x))
      (core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. y))
    ))
    (ext_eq deep (TYPE%core!option.Option. V&. V&) x y)
   )
   :pattern ((ext_eq deep (TYPE%core!option.Option. V&. V&) x y))
   :qid internal_core!option.Option./Some_ext_equal_definition
   :skolemid skolem_internal_core!option.Option./Some_ext_equal_definition
)))
(assert
 (forall ((x core!result.Result.)) (!
   (= x (%Poly%core!result.Result. (Poly%core!result.Result. x)))
   :pattern ((Poly%core!result.Result. x))
   :qid internal_core__result__Result_box_axiom_definition
   :skolemid skolem_internal_core__result__Result_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
    (= x (Poly%core!result.Result. (%Poly%core!result.Result. x)))
   )
   :pattern ((has_type x (TYPE%core!result.Result. T&. T& E&. E&)))
   :qid internal_core__result__Result_unbox_axiom_definition
   :skolemid skolem_internal_core__result__Result_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (_0! Poly)) (!
   (=>
    (has_type _0! T&)
    (has_type (Poly%core!result.Result. (core!result.Result./Ok _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :pattern ((has_type (Poly%core!result.Result. (core!result.Result./Ok _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :qid internal_core!result.Result./Ok_constructor_definition
   :skolemid skolem_internal_core!result.Result./Ok_constructor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Ok x)
    (= (core!result.Result./Ok/0 T&. T& E&. E& x) (core!result.Result./Ok/?0 x))
   )
   :pattern ((core!result.Result./Ok/0 T&. T& E&. E& x))
   :qid internal_core!result.Result./Ok/0_accessor_definition
   :skolemid skolem_internal_core!result.Result./Ok/0_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
    (has_type (core!result.Result./Ok/0 T&. T& E&. E& (%Poly%core!result.Result. x)) T&)
   )
   :pattern ((core!result.Result./Ok/0 T&. T& E&. E& (%Poly%core!result.Result. x)) (
     has_type x (TYPE%core!result.Result. T&. T& E&. E&)
   ))
   :qid internal_core!result.Result./Ok/0_invariant_definition
   :skolemid skolem_internal_core!result.Result./Ok/0_invariant_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (_0! Poly)) (!
   (=>
    (has_type _0! E&)
    (has_type (Poly%core!result.Result. (core!result.Result./Err _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :pattern ((has_type (Poly%core!result.Result. (core!result.Result./Err _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :qid internal_core!result.Result./Err_constructor_definition
   :skolemid skolem_internal_core!result.Result./Err_constructor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Err x)
    (= (core!result.Result./Err/0 T&. T& E&. E& x) (core!result.Result./Err/?0 x))
   )
   :pattern ((core!result.Result./Err/0 T&. T& E&. E& x))
   :qid internal_core!result.Result./Err/0_accessor_definition
   :skolemid skolem_internal_core!result.Result./Err/0_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
    (has_type (core!result.Result./Err/0 T&. T& E&. E& (%Poly%core!result.Result. x))
     E&
   ))
   :pattern ((core!result.Result./Err/0 T&. T& E&. E& (%Poly%core!result.Result. x))
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
   )
   :qid internal_core!result.Result./Err/0_invariant_definition
   :skolemid skolem_internal_core!result.Result./Err/0_invariant_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Ok x)
    (height_lt (height (core!result.Result./Ok/0 T&. T& E&. E& x)) (height (Poly%core!result.Result.
       x
   ))))
   :pattern ((height (core!result.Result./Ok/0 T&. T& E&. E& x)))
   :qid prelude_datatype_height_core!result.Result./Ok/0
   :skolemid skolem_prelude_datatype_height_core!result.Result./Ok/0
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Err x)
    (height_lt (height (core!result.Result./Err/0 T&. T& E&. E& x)) (height (Poly%core!result.Result.
       x
   ))))
   :pattern ((height (core!result.Result./Err/0 T&. T& E&. E& x)))
   :qid prelude_datatype_height_core!result.Result./Err/0
   :skolemid skolem_prelude_datatype_height_core!result.Result./Err/0
)))
(assert
 (forall ((x core!ops.range.Range.)) (!
   (= x (%Poly%core!ops.range.Range. (Poly%core!ops.range.Range. x)))
   :pattern ((Poly%core!ops.range.Range. x))
   :qid internal_core__ops__range__Range_box_axiom_definition
   :skolemid skolem_internal_core__ops__range__Range_box_axiom_definition
)))
(assert
 (forall ((Idx&. Dcr) (Idx& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!ops.range.Range. Idx&. Idx&))
    (= x (Poly%core!ops.range.Range. (%Poly%core!ops.range.Range. x)))
   )
   :pattern ((has_type x (TYPE%core!ops.range.Range. Idx&. Idx&)))
   :qid internal_core__ops__range__Range_unbox_axiom_definition
   :skolemid skolem_internal_core__ops__range__Range_unbox_axiom_definition
)))
(assert
 (forall ((Idx&. Dcr) (Idx& Type) (_start! Poly) (_end! Poly)) (!
   (=>
    (and
     (has_type _start! Idx&)
     (has_type _end! Idx&)
    )
    (has_type (Poly%core!ops.range.Range. (core!ops.range.Range./Range _start! _end!))
     (TYPE%core!ops.range.Range. Idx&. Idx&)
   ))
   :pattern ((has_type (Poly%core!ops.range.Range. (core!ops.range.Range./Range _start!
       _end!
      )
     ) (TYPE%core!ops.range.Range. Idx&. Idx&)
   ))
   :qid internal_core!ops.range.Range./Range_constructor_definition
   :skolemid skolem_internal_core!ops.range.Range./Range_constructor_definition
)))
(assert
 (forall ((x core!ops.range.Range.)) (!
   (= (core!ops.range.Range./Range/start x) (core!ops.range.Range./Range/?start x))
   :pattern ((core!ops.range.Range./Range/start x))
   :qid internal_core!ops.range.Range./Range/start_accessor_definition
   :skolemid skolem_internal_core!ops.range.Range./Range/start_accessor_definition
)))
(assert
 (forall ((Idx&. Dcr) (Idx& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!ops.range.Range. Idx&. Idx&))
    (has_type (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. x)) Idx&)
   )
   :pattern ((core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. x)) (has_type
     x (TYPE%core!ops.range.Range. Idx&. Idx&)
   ))
   :qid internal_core!ops.range.Range./Range/start_invariant_definition
   :skolemid skolem_internal_core!ops.range.Range./Range/start_invariant_definition
)))
(assert
 (forall ((x core!ops.range.Range.)) (!
   (= (core!ops.range.Range./Range/end x) (core!ops.range.Range./Range/?end x))
   :pattern ((core!ops.range.Range./Range/end x))
   :qid internal_core!ops.range.Range./Range/end_accessor_definition
   :skolemid skolem_internal_core!ops.range.Range./Range/end_accessor_definition
)))
(assert
 (forall ((Idx&. Dcr) (Idx& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!ops.range.Range. Idx&. Idx&))
    (has_type (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. x)) Idx&)
   )
   :pattern ((core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. x)) (has_type
     x (TYPE%core!ops.range.Range. Idx&. Idx&)
   ))
   :qid internal_core!ops.range.Range./Range/end_invariant_definition
   :skolemid skolem_internal_core!ops.range.Range./Range/end_invariant_definition
)))
(assert
 (forall ((x core!ops.range.Range.)) (!
   (=>
    (is-core!ops.range.Range./Range x)
    (height_lt (height (core!ops.range.Range./Range/start x)) (height (Poly%core!ops.range.Range.
       x
   ))))
   :pattern ((height (core!ops.range.Range./Range/start x)))
   :qid prelude_datatype_height_core!ops.range.Range./Range/start
   :skolemid skolem_prelude_datatype_height_core!ops.range.Range./Range/start
)))
(assert
 (forall ((x core!ops.range.Range.)) (!
   (=>
    (is-core!ops.range.Range./Range x)
    (height_lt (height (core!ops.range.Range./Range/end x)) (height (Poly%core!ops.range.Range.
       x
   ))))
   :pattern ((height (core!ops.range.Range./Range/end x)))
   :qid prelude_datatype_height_core!ops.range.Range./Range/end
   :skolemid skolem_prelude_datatype_height_core!ops.range.Range./Range/end
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (= x (%Poly%vstd!std_specs.range.RangeGhostIterator. (Poly%vstd!std_specs.range.RangeGhostIterator.
      x
   )))
   :pattern ((Poly%vstd!std_specs.range.RangeGhostIterator. x))
   :qid internal_vstd__std_specs__range__RangeGhostIterator_box_axiom_definition
   :skolemid skolem_internal_vstd__std_specs__range__RangeGhostIterator_box_axiom_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    (= x (Poly%vstd!std_specs.range.RangeGhostIterator. (%Poly%vstd!std_specs.range.RangeGhostIterator.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&)))
   :qid internal_vstd__std_specs__range__RangeGhostIterator_unbox_axiom_definition
   :skolemid skolem_internal_vstd__std_specs__range__RangeGhostIterator_unbox_axiom_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type) (_start! Poly) (_cur! Poly) (_end! Poly)) (!
   (=>
    (and
     (has_type _start! A&)
     (has_type _cur! A&)
     (has_type _end! A&)
    )
    (has_type (Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator
       _start! _cur! _end!
      )
     ) (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&)
   ))
   :pattern ((has_type (Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator
       _start! _cur! _end!
      )
     ) (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&)
   ))
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator_constructor_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator_constructor_definition
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start x) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?start
     x
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start x))
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start_accessor_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start_accessor_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    (has_type (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
       x
      )
     ) A&
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
      x
     )
    ) (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
   )
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start_invariant_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start_invariant_definition
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur x) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?cur
     x
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur x))
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur_accessor_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur_accessor_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    (has_type (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
       x
      )
     ) A&
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
      x
     )
    ) (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
   )
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur_invariant_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur_invariant_definition
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end x) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?end
     x
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end x))
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end_accessor_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end_accessor_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    (has_type (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
       x
      )
     ) A&
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
      x
     )
    ) (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
   )
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end_invariant_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end_invariant_definition
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (=>
    (is-vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator x)
    (height_lt (height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
       x
      )
     ) (height (Poly%vstd!std_specs.range.RangeGhostIterator. x))
   ))
   :pattern ((height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
      x
   )))
   :qid prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
   :skolemid skolem_prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (=>
    (is-vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator x)
    (height_lt (height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
       x
      )
     ) (height (Poly%vstd!std_specs.range.RangeGhostIterator. x))
   ))
   :pattern ((height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur x)))
   :qid prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
   :skolemid skolem_prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (=>
    (is-vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator x)
    (height_lt (height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end
       x
      )
     ) (height (Poly%vstd!std_specs.range.RangeGhostIterator. x))
   ))
   :pattern ((height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end x)))
   :qid prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end
   :skolemid skolem_prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= x (%Poly%vstd!raw_ptr.PtrData. (Poly%vstd!raw_ptr.PtrData. x)))
   :pattern ((Poly%vstd!raw_ptr.PtrData. x))
   :qid internal_vstd__raw_ptr__PtrData_box_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__PtrData_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (= x (Poly%vstd!raw_ptr.PtrData. (%Poly%vstd!raw_ptr.PtrData. x)))
   )
   :pattern ((has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&)))
   :qid internal_vstd__raw_ptr__PtrData_unbox_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__PtrData_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (_addr! Int) (_provenance! vstd!raw_ptr.Provenance.) (
    _metadata! Poly
   )
  ) (!
   (=>
    (and
     (uInv SZ _addr!)
     (has_type _metadata! (pointee_metadata% T&.))
    )
    (has_type (Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData./PtrData _addr! _provenance!
       _metadata!
      )
     ) (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :pattern ((has_type (Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData./PtrData _addr!
       _provenance! _metadata!
      )
     ) (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :qid internal_vstd!raw_ptr.PtrData./PtrData_constructor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData_constructor_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/addr x) (vstd!raw_ptr.PtrData./PtrData/?addr x))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/addr x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/addr_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/addr_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (uInv SZ (vstd!raw_ptr.PtrData./PtrData/addr (%Poly%vstd!raw_ptr.PtrData. x)))
   )
   :pattern ((vstd!raw_ptr.PtrData./PtrData/addr (%Poly%vstd!raw_ptr.PtrData. x)) (has_type
     x (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/addr_invariant_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/addr_invariant_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/provenance x) (vstd!raw_ptr.PtrData./PtrData/?provenance
     x
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/provenance x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/provenance_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/provenance_accessor_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/metadata x) (vstd!raw_ptr.PtrData./PtrData/?metadata
     x
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/metadata x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/metadata_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/metadata_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (has_type (vstd!raw_ptr.PtrData./PtrData/metadata (%Poly%vstd!raw_ptr.PtrData. x))
     (pointee_metadata% T&.)
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/metadata (%Poly%vstd!raw_ptr.PtrData. x))
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
   )
   :qid internal_vstd!raw_ptr.PtrData./PtrData/metadata_invariant_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/metadata_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= x (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. x))
   :qid internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (= x (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.))
   :qid internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_unbox_axiom_definition
)))
(assert
 (forall ((_limbs! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
       _limbs!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 _limbs!)
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :qid internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
     x
    ) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/?limbs
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (has_type (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
       (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. x)
      )
     ) (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
     (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   )
   :qid internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= x (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
     (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
   ))
   :pattern ((Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
     x
   ))
   :qid internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.)
    (= x (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
   )))
   :pattern ((has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
   :qid internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_unbox_axiom_definition
)))
(assert
 (forall ((_gcd! Int) (_x! Int) (_y! Int)) (!
   (=>
    (<= 0 _gcd!)
    (has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
       _gcd! _x! _y!
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
       _gcd! _x! _y!
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
     x
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?gcd
     x
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
     x
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.)
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
      (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
     (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
    ) (has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.)
   )
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
     x
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?x
     x
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
     x
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x_accessor_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
     x
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?y
     x
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
     x
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y_accessor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.CompletedPoint.)) (!
   (= x (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x))
   :qid internal_curve25519_dalek__backend__serial__curve_models__CompletedPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__CompletedPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (= x (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.))
   :qid internal_curve25519_dalek__backend__serial__curve_models__CompletedPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__CompletedPoint_unbox_axiom_definition
)))
(assert
 (forall ((_X! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_Y! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (_Z! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_T! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _X!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Z!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _T!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint
       _X! _Y! _Z! _T!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
      (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint _X! _Y!
       _Z! _T!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.CompletedPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X x)
    (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?X x)
   )
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X
       (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X
     (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.CompletedPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y x)
    (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?Y x)
   )
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y
       (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y
     (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.CompletedPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z x)
    (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?Z x)
   )
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z
       (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z
     (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.CompletedPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T x)
    (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?T x)
   )
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T
       (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T
     (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)) (!
   (= x (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x))
   :qid internal_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (= x (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
   :qid internal_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint_unbox_axiom_definition
)))
(assert
 (forall ((_y_plus_x! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_y_minus_x!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (_xy2d! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _y_plus_x!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _y_minus_x!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _xy2d!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ))
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint
       _y_plus_x! _y_minus_x! _xy2d!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint _y_plus_x!
       _y_minus_x! _xy2d!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
     x
    ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?y_plus_x
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
       (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
     (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
     x
    ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?y_minus_x
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
       (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
     (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
     x
    ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?xy2d
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
       (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
     (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= x (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
     x
   ))
   :qid internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (= x (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
   :qid internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_unbox_axiom_definition
)))
(assert
 (forall ((_Y_plus_X! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_Y_minus_X!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (_Z! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_T2d! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y_plus_X!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y_minus_X!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Z!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _T2d!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
       _Y_plus_X! _Y_minus_X! _Z! _T2d!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
       _Y_plus_X! _Y_minus_X! _Z! _T2d!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_plus_X
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_minus_X
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Z
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?T2d
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= x (%Poly%curve25519_dalek!edwards.EdwardsPoint. (Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!edwards.EdwardsPoint. x))
   :qid internal_curve25519_dalek__edwards__EdwardsPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__edwards__EdwardsPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (= x (Poly%curve25519_dalek!edwards.EdwardsPoint. (%Poly%curve25519_dalek!edwards.EdwardsPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.))
   :qid internal_curve25519_dalek__edwards__EdwardsPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__edwards__EdwardsPoint_unbox_axiom_definition
)))
(assert
 (forall ((_X! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_Y! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (_Z! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_T! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _X!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Z!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _T!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!edwards.EdwardsPoint. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint
       _X! _Y! _Z! _T!
      )
     ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!edwards.EdwardsPoint. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint
       _X! _Y! _Z! _T!
      )
     ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?X
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Y
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Z
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?T
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!window.LookupTable.)) (!
   (= x (%Poly%curve25519_dalek!window.LookupTable. (Poly%curve25519_dalek!window.LookupTable.
      x
   )))
   :pattern ((Poly%curve25519_dalek!window.LookupTable. x))
   :qid internal_curve25519_dalek__window__LookupTable_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__window__LookupTable_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%curve25519_dalek!window.LookupTable. T&. T&))
    (= x (Poly%curve25519_dalek!window.LookupTable. (%Poly%curve25519_dalek!window.LookupTable.
       x
   ))))
   :pattern ((has_type x (TYPE%curve25519_dalek!window.LookupTable. T&. T&)))
   :qid internal_curve25519_dalek__window__LookupTable_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__window__LookupTable_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (_0! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _0!) (ARRAY T&. T& $ (CONST_INT 8)))
    (has_type (Poly%curve25519_dalek!window.LookupTable. (curve25519_dalek!window.LookupTable./LookupTable
       _0!
      )
     ) (TYPE%curve25519_dalek!window.LookupTable. T&. T&)
   ))
   :pattern ((has_type (Poly%curve25519_dalek!window.LookupTable. (curve25519_dalek!window.LookupTable./LookupTable
       _0!
      )
     ) (TYPE%curve25519_dalek!window.LookupTable. T&. T&)
   ))
   :qid internal_curve25519_dalek!window.LookupTable./LookupTable_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!window.LookupTable./LookupTable_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!window.LookupTable.)) (!
   (= (curve25519_dalek!window.LookupTable./LookupTable/0 x) (curve25519_dalek!window.LookupTable./LookupTable/?0
     x
   ))
   :pattern ((curve25519_dalek!window.LookupTable./LookupTable/0 x))
   :qid internal_curve25519_dalek!window.LookupTable./LookupTable/0_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!window.LookupTable./LookupTable/0_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%curve25519_dalek!window.LookupTable. T&. T&))
    (has_type (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
        x
      ))
     ) (ARRAY T&. T& $ (CONST_INT 8))
   ))
   :pattern ((curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
      x
     )
    ) (has_type x (TYPE%curve25519_dalek!window.LookupTable. T&. T&))
   )
   :qid internal_curve25519_dalek!window.LookupTable./LookupTable/0_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!window.LookupTable./LookupTable/0_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!window.NafLookupTable5.)) (!
   (= x (%Poly%curve25519_dalek!window.NafLookupTable5. (Poly%curve25519_dalek!window.NafLookupTable5.
      x
   )))
   :pattern ((Poly%curve25519_dalek!window.NafLookupTable5. x))
   :qid internal_curve25519_dalek__window__NafLookupTable5_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__window__NafLookupTable5_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%curve25519_dalek!window.NafLookupTable5. T&. T&))
    (= x (Poly%curve25519_dalek!window.NafLookupTable5. (%Poly%curve25519_dalek!window.NafLookupTable5.
       x
   ))))
   :pattern ((has_type x (TYPE%curve25519_dalek!window.NafLookupTable5. T&. T&)))
   :qid internal_curve25519_dalek__window__NafLookupTable5_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__window__NafLookupTable5_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (_0! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _0!) (ARRAY T&. T& $ (CONST_INT 8)))
    (has_type (Poly%curve25519_dalek!window.NafLookupTable5. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5
       _0!
      )
     ) (TYPE%curve25519_dalek!window.NafLookupTable5. T&. T&)
   ))
   :pattern ((has_type (Poly%curve25519_dalek!window.NafLookupTable5. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5
       _0!
      )
     ) (TYPE%curve25519_dalek!window.NafLookupTable5. T&. T&)
   ))
   :qid internal_curve25519_dalek!window.NafLookupTable5./NafLookupTable5_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!window.NafLookupTable5./NafLookupTable5_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!window.NafLookupTable5.)) (!
   (= (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 x) (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/?0
     x
   ))
   :pattern ((curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 x))
   :qid internal_curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%curve25519_dalek!window.NafLookupTable5. T&. T&))
    (has_type (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0
       (%Poly%curve25519_dalek!window.NafLookupTable5. x)
      )
     ) (ARRAY T&. T& $ (CONST_INT 8))
   ))
   :pattern ((curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
      x
     )
    ) (has_type x (TYPE%curve25519_dalek!window.NafLookupTable5. T&. T&))
   )
   :qid internal_curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!window.NafLookupTable8.)) (!
   (= x (%Poly%curve25519_dalek!window.NafLookupTable8. (Poly%curve25519_dalek!window.NafLookupTable8.
      x
   )))
   :pattern ((Poly%curve25519_dalek!window.NafLookupTable8. x))
   :qid internal_curve25519_dalek__window__NafLookupTable8_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__window__NafLookupTable8_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%curve25519_dalek!window.NafLookupTable8. T&. T&))
    (= x (Poly%curve25519_dalek!window.NafLookupTable8. (%Poly%curve25519_dalek!window.NafLookupTable8.
       x
   ))))
   :pattern ((has_type x (TYPE%curve25519_dalek!window.NafLookupTable8. T&. T&)))
   :qid internal_curve25519_dalek__window__NafLookupTable8_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__window__NafLookupTable8_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (_0! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _0!) (ARRAY T&. T& $ (CONST_INT 64)))
    (has_type (Poly%curve25519_dalek!window.NafLookupTable8. (curve25519_dalek!window.NafLookupTable8./NafLookupTable8
       _0!
      )
     ) (TYPE%curve25519_dalek!window.NafLookupTable8. T&. T&)
   ))
   :pattern ((has_type (Poly%curve25519_dalek!window.NafLookupTable8. (curve25519_dalek!window.NafLookupTable8./NafLookupTable8
       _0!
      )
     ) (TYPE%curve25519_dalek!window.NafLookupTable8. T&. T&)
   ))
   :qid internal_curve25519_dalek!window.NafLookupTable8./NafLookupTable8_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!window.NafLookupTable8./NafLookupTable8_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!window.NafLookupTable8.)) (!
   (= (curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0 x) (curve25519_dalek!window.NafLookupTable8./NafLookupTable8/?0
     x
   ))
   :pattern ((curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0 x))
   :qid internal_curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%curve25519_dalek!window.NafLookupTable8. T&. T&))
    (has_type (Poly%array%. (curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0
       (%Poly%curve25519_dalek!window.NafLookupTable8. x)
      )
     ) (ARRAY T&. T& $ (CONST_INT 64))
   ))
   :pattern ((curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0 (%Poly%curve25519_dalek!window.NafLookupTable8.
      x
     )
    ) (has_type x (TYPE%curve25519_dalek!window.NafLookupTable8. T&. T&))
   )
   :qid internal_curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0_invariant_definition
)))
(assert
 (forall ((x tuple%0.)) (!
   (= x (%Poly%tuple%0. (Poly%tuple%0. x)))
   :pattern ((Poly%tuple%0. x))
   :qid internal_crate__tuple__0_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__0_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%tuple%0.)
    (= x (Poly%tuple%0. (%Poly%tuple%0. x)))
   )
   :pattern ((has_type x TYPE%tuple%0.))
   :qid internal_crate__tuple__0_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__0_unbox_axiom_definition
)))
(assert
 (forall ((x tuple%0.)) (!
   (has_type (Poly%tuple%0. x) TYPE%tuple%0.)
   :pattern ((has_type (Poly%tuple%0. x) TYPE%tuple%0.))
   :qid internal_crate__tuple__0_has_type_always_definition
   :skolemid skolem_internal_crate__tuple__0_has_type_always_definition
)))
(assert
 (forall ((x tuple%1.)) (!
   (= x (%Poly%tuple%1. (Poly%tuple%1. x)))
   :pattern ((Poly%tuple%1. x))
   :qid internal_crate__tuple__1_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__1_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%1. T%0&. T%0&))
    (= x (Poly%tuple%1. (%Poly%tuple%1. x)))
   )
   :pattern ((has_type x (TYPE%tuple%1. T%0&. T%0&)))
   :qid internal_crate__tuple__1_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__1_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (_0! Poly)) (!
   (=>
    (has_type _0! T%0&)
    (has_type (Poly%tuple%1. (tuple%1./tuple%1 _0!)) (TYPE%tuple%1. T%0&. T%0&))
   )
   :pattern ((has_type (Poly%tuple%1. (tuple%1./tuple%1 _0!)) (TYPE%tuple%1. T%0&. T%0&)))
   :qid internal_tuple__1./tuple__1_constructor_definition
   :skolemid skolem_internal_tuple__1./tuple__1_constructor_definition
)))
(assert
 (forall ((x tuple%1.)) (!
   (= (tuple%1./tuple%1/0 x) (tuple%1./tuple%1/?0 x))
   :pattern ((tuple%1./tuple%1/0 x))
   :qid internal_tuple__1./tuple__1/0_accessor_definition
   :skolemid skolem_internal_tuple__1./tuple__1/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%1. T%0&. T%0&))
    (has_type (tuple%1./tuple%1/0 (%Poly%tuple%1. x)) T%0&)
   )
   :pattern ((tuple%1./tuple%1/0 (%Poly%tuple%1. x)) (has_type x (TYPE%tuple%1. T%0&. T%0&)))
   :qid internal_tuple__1./tuple__1/0_invariant_definition
   :skolemid skolem_internal_tuple__1./tuple__1/0_invariant_definition
)))
(assert
 (forall ((x tuple%1.)) (!
   (=>
    (is-tuple%1./tuple%1 x)
    (height_lt (height (tuple%1./tuple%1/0 x)) (height (Poly%tuple%1. x)))
   )
   :pattern ((height (tuple%1./tuple%1/0 x)))
   :qid prelude_datatype_height_tuple%1./tuple%1/0
   :skolemid skolem_prelude_datatype_height_tuple%1./tuple%1/0
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x (TYPE%tuple%1. T%0&. T%0&))
     (has_type y (TYPE%tuple%1. T%0&. T%0&))
     (ext_eq deep T%0& (tuple%1./tuple%1/0 (%Poly%tuple%1. x)) (tuple%1./tuple%1/0 (%Poly%tuple%1.
        y
    ))))
    (ext_eq deep (TYPE%tuple%1. T%0&. T%0&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%1. T%0&. T%0&) x y))
   :qid internal_tuple__1./tuple__1_ext_equal_definition
   :skolemid skolem_internal_tuple__1./tuple__1_ext_equal_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= x (%Poly%tuple%2. (Poly%tuple%2. x)))
   :pattern ((Poly%tuple%2. x))
   :qid internal_crate__tuple__2_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__2_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (= x (Poly%tuple%2. (%Poly%tuple%2. x)))
   )
   :pattern ((has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__tuple__2_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__2_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (_0! Poly) (_1! Poly)) (!
   (=>
    (and
     (has_type _0! T%0&)
     (has_type _1! T%1&)
    )
    (has_type (Poly%tuple%2. (tuple%2./tuple%2 _0! _1!)) (TYPE%tuple%2. T%0&. T%0& T%1&.
      T%1&
   )))
   :pattern ((has_type (Poly%tuple%2. (tuple%2./tuple%2 _0! _1!)) (TYPE%tuple%2. T%0&.
      T%0& T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2_constructor_definition
   :skolemid skolem_internal_tuple__2./tuple__2_constructor_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= (tuple%2./tuple%2/0 x) (tuple%2./tuple%2/?0 x))
   :pattern ((tuple%2./tuple%2/0 x))
   :qid internal_tuple__2./tuple__2/0_accessor_definition
   :skolemid skolem_internal_tuple__2./tuple__2/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (has_type (tuple%2./tuple%2/0 (%Poly%tuple%2. x)) T%0&)
   )
   :pattern ((tuple%2./tuple%2/0 (%Poly%tuple%2. x)) (has_type x (TYPE%tuple%2. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2/0_invariant_definition
   :skolemid skolem_internal_tuple__2./tuple__2/0_invariant_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= (tuple%2./tuple%2/1 x) (tuple%2./tuple%2/?1 x))
   :pattern ((tuple%2./tuple%2/1 x))
   :qid internal_tuple__2./tuple__2/1_accessor_definition
   :skolemid skolem_internal_tuple__2./tuple__2/1_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (has_type (tuple%2./tuple%2/1 (%Poly%tuple%2. x)) T%1&)
   )
   :pattern ((tuple%2./tuple%2/1 (%Poly%tuple%2. x)) (has_type x (TYPE%tuple%2. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2/1_invariant_definition
   :skolemid skolem_internal_tuple__2./tuple__2/1_invariant_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (=>
    (is-tuple%2./tuple%2 x)
    (height_lt (height (tuple%2./tuple%2/0 x)) (height (Poly%tuple%2. x)))
   )
   :pattern ((height (tuple%2./tuple%2/0 x)))
   :qid prelude_datatype_height_tuple%2./tuple%2/0
   :skolemid skolem_prelude_datatype_height_tuple%2./tuple%2/0
)))
(assert
 (forall ((x tuple%2.)) (!
   (=>
    (is-tuple%2./tuple%2 x)
    (height_lt (height (tuple%2./tuple%2/1 x)) (height (Poly%tuple%2. x)))
   )
   :pattern ((height (tuple%2./tuple%2/1 x)))
   :qid prelude_datatype_height_tuple%2./tuple%2/1
   :skolemid skolem_prelude_datatype_height_tuple%2./tuple%2/1
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (deep Bool) (x Poly) (y Poly))
  (!
   (=>
    (and
     (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
     (has_type y (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
     (ext_eq deep T%0& (tuple%2./tuple%2/0 (%Poly%tuple%2. x)) (tuple%2./tuple%2/0 (%Poly%tuple%2.
        y
     )))
     (ext_eq deep T%1& (tuple%2./tuple%2/1 (%Poly%tuple%2. x)) (tuple%2./tuple%2/1 (%Poly%tuple%2.
        y
    ))))
    (ext_eq deep (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&) x y))
   :qid internal_tuple__2./tuple__2_ext_equal_definition
   :skolemid skolem_internal_tuple__2./tuple__2_ext_equal_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= x (%Poly%tuple%4. (Poly%tuple%4. x)))
   :pattern ((Poly%tuple%4. x))
   :qid internal_crate__tuple__4_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__4_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (= x (Poly%tuple%4. (%Poly%tuple%4. x)))
   )
   :pattern ((has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&)))
   :qid internal_crate__tuple__4_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__4_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (_0! Poly) (_1! Poly) (_2! Poly) (_3! Poly)
  ) (!
   (=>
    (and
     (has_type _0! T%0&)
     (has_type _1! T%1&)
     (has_type _2! T%2&)
     (has_type _3! T%3&)
    )
    (has_type (Poly%tuple%4. (tuple%4./tuple%4 _0! _1! _2! _3!)) (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :pattern ((has_type (Poly%tuple%4. (tuple%4./tuple%4 _0! _1! _2! _3!)) (TYPE%tuple%4.
      T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4_constructor_definition
   :skolemid skolem_internal_tuple__4./tuple__4_constructor_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/0 x) (tuple%4./tuple%4/?0 x))
   :pattern ((tuple%4./tuple%4/0 x))
   :qid internal_tuple__4./tuple__4/0_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/0 (%Poly%tuple%4. x)) T%0&)
   )
   :pattern ((tuple%4./tuple%4/0 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/0_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/0_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/1 x) (tuple%4./tuple%4/?1 x))
   :pattern ((tuple%4./tuple%4/1 x))
   :qid internal_tuple__4./tuple__4/1_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/1_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/1 (%Poly%tuple%4. x)) T%1&)
   )
   :pattern ((tuple%4./tuple%4/1 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/1_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/1_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/2 x) (tuple%4./tuple%4/?2 x))
   :pattern ((tuple%4./tuple%4/2 x))
   :qid internal_tuple__4./tuple__4/2_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/2_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/2 (%Poly%tuple%4. x)) T%2&)
   )
   :pattern ((tuple%4./tuple%4/2 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/2_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/2_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/3 x) (tuple%4./tuple%4/?3 x))
   :pattern ((tuple%4./tuple%4/3 x))
   :qid internal_tuple__4./tuple__4/3_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/3_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/3 (%Poly%tuple%4. x)) T%3&)
   )
   :pattern ((tuple%4./tuple%4/3 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/3_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/3_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/0 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/0 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/0
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/0
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/1 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/1 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/1
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/1
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/2 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/2 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/2
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/2
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/3 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/3 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/3
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/3
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (deep Bool) (x Poly) (y Poly)
  ) (!
   (=>
    (and
     (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
     (has_type y (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
     (ext_eq deep T%0& (tuple%4./tuple%4/0 (%Poly%tuple%4. x)) (tuple%4./tuple%4/0 (%Poly%tuple%4.
        y
     )))
     (ext_eq deep T%1& (tuple%4./tuple%4/1 (%Poly%tuple%4. x)) (tuple%4./tuple%4/1 (%Poly%tuple%4.
        y
     )))
     (ext_eq deep T%2& (tuple%4./tuple%4/2 (%Poly%tuple%4. x)) (tuple%4./tuple%4/2 (%Poly%tuple%4.
        y
     )))
     (ext_eq deep T%3& (tuple%4./tuple%4/3 (%Poly%tuple%4. x)) (tuple%4./tuple%4/3 (%Poly%tuple%4.
        y
    ))))
    (ext_eq deep (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&)
     x y
   ))
   :qid internal_tuple__4./tuple__4_ext_equal_definition
   :skolemid skolem_internal_tuple__4./tuple__4_ext_equal_definition
)))
(declare-fun array_new (Dcr Type Int %%Function%%) Poly)
(declare-fun array_index (Dcr Type Dcr Type %%Function%% Poly) Poly)
(assert
 (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%)) (!
   (= (array_new Tdcr T N Fn) (Poly%array%. Fn))
   :pattern ((array_new Tdcr T N Fn))
   :qid prelude_array_new
   :skolemid skolem_prelude_array_new
)))
(declare-fun %%apply%%1 (%%Function%% Int) Poly)
(assert
 (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%)) (!
   (=>
    (forall ((i Int)) (!
      (=>
       (and
        (<= 0 i)
        (< i N)
       )
       (has_type (%%apply%%1 Fn i) T)
      )
      :pattern ((has_type (%%apply%%1 Fn i) T))
      :qid prelude_has_type_array_elts
      :skolemid skolem_prelude_has_type_array_elts
    ))
    (has_type (array_new Tdcr T N Fn) (ARRAY Tdcr T $ (CONST_INT N)))
   )
   :pattern ((array_new Tdcr T N Fn))
   :qid prelude_has_type_array_new
   :skolemid skolem_prelude_has_type_array_new
)))
(assert
 (forall ((Tdcr Dcr) (T Type) (Ndcr Dcr) (N Type) (Fn %%Function%%) (i Poly)) (!
   (=>
    (and
     (has_type (Poly%array%. Fn) (ARRAY Tdcr T Ndcr N))
     (has_type i INT)
    )
    (has_type (array_index Tdcr T $ N Fn i) T)
   )
   :pattern ((array_index Tdcr T $ N Fn i) (has_type (Poly%array%. Fn) (ARRAY Tdcr T Ndcr
      N
   )))
   :qid prelude_has_type_array_index
   :skolemid skolem_prelude_has_type_array_index
)))
(assert
 (!
  (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%) (i Int)) (!
    (= (array_index Tdcr T $ (CONST_INT N) Fn (I i)) (%%apply%%1 Fn i))
    :pattern ((array_new Tdcr T N Fn) (%%apply%%1 Fn i))
    :qid prelude_array_index_trigger
    :skolemid skolem_prelude_array_index_trigger
  ))
  :named
  prelude_axiom_array_index
))
(declare-fun str%strslice_is_ascii (strslice%.) Bool)
(declare-fun str%strslice_len (strslice%.) Int)
(declare-fun str%strslice_get_char (strslice%. Int) Int)
(declare-fun str%new_strlit (Int) strslice%.)
(declare-fun str%from_strlit (strslice%.) Int)
(assert
 (forall ((x Int)) (!
   (= (str%from_strlit (str%new_strlit x)) x)
   :pattern ((str%new_strlit x))
   :qid prelude_strlit_injective
   :skolemid skolem_prelude_strlit_injective
)))

;; Trait-Bounds
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!array.ArrayAdditionalSpecFns. Self%&. Self%& T&. T&)
    (and
     (tr_bound%vstd!view.View. Self%&. Self%&)
     (and
      (= $ (proj%%vstd!view.View./V Self%&. Self%&))
      (= (TYPE%vstd!seq.Seq. T&. T&) (proj%vstd!view.View./V Self%&. Self%&))
     )
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!array.ArrayAdditionalSpecFns. Self%&. Self%& T&. T&))
   :qid internal_vstd__array__ArrayAdditionalSpecFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__array__ArrayAdditionalSpecFns_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!pervasive.ForLoopGhostIterator. Self%&. Self%&)
    (and
     (sized (proj%%vstd!pervasive.ForLoopGhostIterator./ExecIter Self%&. Self%&))
     (sized (proj%%vstd!pervasive.ForLoopGhostIterator./Item Self%&. Self%&))
     (sized (proj%%vstd!pervasive.ForLoopGhostIterator./Decrease Self%&. Self%&))
   ))
   :pattern ((tr_bound%vstd!pervasive.ForLoopGhostIterator. Self%&. Self%&))
   :qid internal_vstd__pervasive__ForLoopGhostIterator_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__pervasive__ForLoopGhostIterator_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!pervasive.ForLoopGhostIteratorNew. Self%&. Self%&)
    (sized (proj%%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter Self%&. Self%&))
   )
   :pattern ((tr_bound%vstd!pervasive.ForLoopGhostIteratorNew. Self%&. Self%&))
   :qid internal_vstd__pervasive__ForLoopGhostIteratorNew_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__pervasive__ForLoopGhostIteratorNew_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Args&. Dcr) (Args& Type) (Output&. Dcr) (Output&
    Type
   )
  ) (!
   (=>
    (tr_bound%vstd!pervasive.FnWithRequiresEnsures. Self%&. Self%& Args&. Args& Output&.
     Output&
    )
    (and
     (sized Self%&.)
     (sized Args&.)
     (sized Output&.)
   ))
   :pattern ((tr_bound%vstd!pervasive.FnWithRequiresEnsures. Self%&. Self%& Args&. Args&
     Output&. Output&
   ))
   :qid internal_vstd__pervasive__FnWithRequiresEnsures_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__pervasive__FnWithRequiresEnsures_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!slice.SliceAdditionalSpecFns. Self%&. Self%& T&. T&)
    (and
     (tr_bound%vstd!view.View. Self%&. Self%&)
     (and
      (= $ (proj%%vstd!view.View./V Self%&. Self%&))
      (= (TYPE%vstd!seq.Seq. T&. T&) (proj%vstd!view.View./V Self%&. Self%&))
     )
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!slice.SliceAdditionalSpecFns. Self%&. Self%& T&. T&))
   :qid internal_vstd__slice__SliceAdditionalSpecFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__slice__SliceAdditionalSpecFns_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   true
   :pattern ((tr_bound%core!slice.index.SliceIndex. Self%&. Self%& T&. T&))
   :qid internal_core__slice__index__SliceIndex_trait_type_bounds_definition
   :skolemid skolem_internal_core__slice__index__SliceIndex_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!view.View. Self%&. Self%&)
    (sized (proj%%vstd!view.View./V Self%&. Self%&))
   )
   :pattern ((tr_bound%vstd!view.View. Self%&. Self%&))
   :qid internal_vstd__view__View_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__view__View_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%core!clone.Clone. Self%&. Self%&)
    (sized Self%&.)
   )
   :pattern ((tr_bound%core!clone.Clone. Self%&. Self%&))
   :qid internal_core__clone__Clone_trait_type_bounds_definition
   :skolemid skolem_internal_core__clone__Clone_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   true
   :pattern ((tr_bound%core!cmp.PartialEq. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_core__cmp__PartialEq_trait_type_bounds_definition
   :skolemid skolem_internal_core__cmp__PartialEq_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%core!cmp.PartialOrd. Self%&. Self%& Rhs&. Rhs&)
    (tr_bound%core!cmp.PartialEq. Self%&. Self%& Rhs&. Rhs&)
   )
   :pattern ((tr_bound%core!cmp.PartialOrd. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_core__cmp__PartialOrd_trait_type_bounds_definition
   :skolemid skolem_internal_core__cmp__PartialOrd_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%core!convert.From. Self%&. Self%& T&. T&)
    (and
     (sized Self%&.)
     (sized T&.)
   ))
   :pattern ((tr_bound%core!convert.From. Self%&. Self%& T&. T&))
   :qid internal_core__convert__From_trait_type_bounds_definition
   :skolemid skolem_internal_core__convert__From_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.convert.FromSpec. Self%&. Self%& T&. T&)
    (and
     (sized Self%&.)
     (tr_bound%core!convert.From. Self%&. Self%& T&. T&)
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.convert.FromSpec. Self%&. Self%& T&. T&))
   :qid internal_vstd__std_specs__convert__FromSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__convert__FromSpec_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Idx&. Dcr) (Idx& Type)) (!
   true
   :pattern ((tr_bound%core!ops.index.Index. Self%&. Self%& Idx&. Idx&))
   :qid internal_core__ops__index__Index_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__index__Index_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Idx&. Dcr) (Idx& Type)) (!
   (=>
    (tr_bound%core!ops.index.IndexMut. Self%&. Self%& Idx&. Idx&)
    (tr_bound%core!ops.index.Index. Self%&. Self%& Idx&. Idx&)
   )
   :pattern ((tr_bound%core!ops.index.IndexMut. Self%&. Self%& Idx&. Idx&))
   :qid internal_core__ops__index__IndexMut_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__index__IndexMut_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   true
   :pattern ((tr_bound%core!alloc.Allocator. Self%&. Self%&))
   :qid internal_core__alloc__Allocator_trait_type_bounds_definition
   :skolemid skolem_internal_core__alloc__Allocator_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   true
   :pattern ((tr_bound%core!fmt.Debug. Self%&. Self%&))
   :qid internal_core__fmt__Debug_trait_type_bounds_definition
   :skolemid skolem_internal_core__fmt__Debug_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%core!iter.traits.iterator.Iterator. Self%&. Self%&)
    (sized (proj%%core!iter.traits.iterator.Iterator./Item Self%&. Self%&))
   )
   :pattern ((tr_bound%core!iter.traits.iterator.Iterator. Self%&. Self%&))
   :qid internal_core__iter__traits__iterator__Iterator_trait_type_bounds_definition
   :skolemid skolem_internal_core__iter__traits__iterator__Iterator_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%core!iter.range.Step. Self%&. Self%&)
    (and
     (sized Self%&.)
     (tr_bound%core!clone.Clone. Self%&. Self%&)
     (tr_bound%core!cmp.PartialOrd. Self%&. Self%& Self%&. Self%&)
   ))
   :pattern ((tr_bound%core!iter.range.Step. Self%&. Self%&))
   :qid internal_core__iter__range__Step_trait_type_bounds_definition
   :skolemid skolem_internal_core__iter__range__Step_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   true
   :pattern ((tr_bound%vstd!std_specs.core.TrustedSpecSealed. Self%&. Self%&))
   :qid internal_vstd__std_specs__core__TrustedSpecSealed_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__core__TrustedSpecSealed_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Idx&. Dcr) (Idx& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. Self%&. Self%& Idx&. Idx&)
    (and
     (tr_bound%core!ops.index.IndexMut. Self%&. Self%& Idx&. Idx&)
     (tr_bound%vstd!std_specs.core.TrustedSpecSealed. Self%&. Self%&)
     (sized Idx&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. Self%&. Self%& Idx&. Idx&))
   :qid internal_vstd__std_specs__core__IndexSetTrustedSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__core__IndexSetTrustedSpec_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%core!default.Default. Self%&. Self%&)
    (sized Self%&.)
   )
   :pattern ((tr_bound%core!default.Default. Self%&. Self%&))
   :qid internal_core__default__Default_trait_type_bounds_definition
   :skolemid skolem_internal_core__default__Default_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%core!ops.arith.Add. Self%&. Self%& Rhs&. Rhs&)
    (and
     (sized Rhs&.)
     (sized (proj%%core!ops.arith.Add./Output Self%&. Self%& Rhs&. Rhs&))
   ))
   :pattern ((tr_bound%core!ops.arith.Add. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_core__ops__arith__Add_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__arith__Add_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.ops.AddSpec. Self%&. Self%& Rhs&. Rhs&)
    (and
     (tr_bound%core!ops.arith.Add. Self%&. Self%& Rhs&. Rhs&)
     (sized Rhs&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.ops.AddSpec. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd__std_specs__ops__AddSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__ops__AddSpec_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.option.OptionAdditionalFns. Self%&. Self%& T&. T&)
    (and
     (sized Self%&.)
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.option.OptionAdditionalFns. Self%&. Self%& T&. T&))
   :qid internal_vstd__std_specs__option__OptionAdditionalFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__option__OptionAdditionalFns_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.range.StepSpec. Self%&. Self%&)
    (sized Self%&.)
   )
   :pattern ((tr_bound%vstd!std_specs.range.StepSpec. Self%&. Self%&))
   :qid internal_vstd__std_specs__range__StepSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__range__StepSpec_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   true
   :pattern ((tr_bound%curve25519_dalek!traits.Identity. Self%&. Self%&))
   :qid internal_curve25519_dalek__traits__Identity_trait_type_bounds_definition
   :skolemid skolem_internal_curve25519_dalek__traits__Identity_trait_type_bounds_definition
)))

;; Associated-Type-Impls
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%%vstd!view.View./V $ (ARRAY T&. T& N&. N&)) $)
   :pattern ((proj%%vstd!view.View./V $ (ARRAY T&. T& N&. N&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%vstd!view.View./V $ (ARRAY T&. T& N&. N&)) (TYPE%vstd!seq.Seq. T&. T&))
   :pattern ((proj%vstd!view.View./V $ (ARRAY T&. T& N&. N&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $ (PTR T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $ (PTR T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $ (PTR T&. T&)) (TYPE%vstd!raw_ptr.PtrData. T&. T&))
   :pattern ((proj%vstd!view.View./V $ (PTR T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)) (TYPE%vstd!raw_ptr.PtrData.
     T&. T&
   ))
   :pattern ((proj%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $slice (SLICE T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $slice (SLICE T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $slice (SLICE T&. T&)) (TYPE%vstd!seq.Seq. T&. T&))
   :pattern ((proj%vstd!view.View./V $slice (SLICE T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (= (proj%%vstd!view.View./V $slice STRSLICE) $)
)
(assert
 (= (proj%vstd!view.View./V $slice STRSLICE) (TYPE%vstd!seq.Seq. $ CHAR))
)
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (REF A&.) A&) (proj%%vstd!view.View./V A&. A&))
   :pattern ((proj%%vstd!view.View./V (REF A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (REF A&.) A&) (proj%vstd!view.View./V A&. A&))
   :pattern ((proj%vstd!view.View./V (REF A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)) (TYPE%core!option.Option.
     T&. T&
   ))
   :pattern ((proj%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (= (proj%%vstd!view.View./V $ TYPE%tuple%0.) $)
)
(assert
 (= (proj%vstd!view.View./V $ TYPE%tuple%0.) TYPE%tuple%0.)
)
(assert
 (= (proj%%vstd!view.View./V $ BOOL) $)
)
(assert
 (= (proj%vstd!view.View./V $ BOOL) BOOL)
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 8)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 16)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 16)) (UINT 16))
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 32)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 64)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%vstd!view.View./V $ USIZE) $)
)
(assert
 (= (proj%vstd!view.View./V $ USIZE) USIZE)
)
(assert
 (= (proj%%vstd!view.View./V $ (SINT 8)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (SINT 8)) (SINT 8))
)
(assert
 (= (proj%%vstd!view.View./V $ (SINT 16)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (SINT 16)) (SINT 16))
)
(assert
 (= (proj%%vstd!view.View./V $ (SINT 32)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%vstd!view.View./V $ CHAR) $)
)
(assert
 (= (proj%vstd!view.View./V $ CHAR) CHAR)
)
(assert
 (forall ((A0&. Dcr) (A0& Type)) (!
   (= (proj%%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)) (DST (proj%%vstd!view.View./V
      A0&. A0&
   )))
   :pattern ((proj%%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type)) (!
   (= (proj%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)) (TYPE%tuple%1. (proj%%vstd!view.View./V
      A0&. A0&
     ) (proj%vstd!view.View./V A0&. A0&)
   ))
   :pattern ((proj%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (= (proj%%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)) (DST (proj%%vstd!view.View./V
      A1&. A1&
   )))
   :pattern ((proj%%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (= (proj%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)) (TYPE%tuple%2.
     (proj%%vstd!view.View./V A0&. A0&) (proj%vstd!view.View./V A0&. A0&) (proj%%vstd!view.View./V
      A1&. A1&
     ) (proj%vstd!view.View./V A1&. A1&)
   ))
   :pattern ((proj%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
   (A3& Type)
  ) (!
   (= (proj%%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
      A3&
     )
    ) (DST (proj%%vstd!view.View./V A3&. A3&))
   )
   :pattern ((proj%%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&.
      A2& A3&. A3&
   )))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
   (A3& Type)
  ) (!
   (= (proj%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
      A3&
     )
    ) (TYPE%tuple%4. (proj%%vstd!view.View./V A0&. A0&) (proj%vstd!view.View./V A0&. A0&)
     (proj%%vstd!view.View./V A1&. A1&) (proj%vstd!view.View./V A1&. A1&) (proj%%vstd!view.View./V
      A2&. A2&
     ) (proj%vstd!view.View./V A2&. A2&) (proj%%vstd!view.View./V A3&. A3&) (proj%vstd!view.View./V
      A3&. A3&
   )))
   :pattern ((proj%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2&
      A3&. A3&
   )))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter $ (TYPE%core!ops.range.Range.
      A&. A&
     )
    ) $
   )
   :pattern ((proj%%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_proj____vstd!pervasive.ForLoopGhostIteratorNew./GhostIter_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!pervasive.ForLoopGhostIteratorNew./GhostIter_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter $ (TYPE%core!ops.range.Range.
      A&. A&
     )
    ) (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&)
   )
   :pattern ((proj%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_proj__vstd!pervasive.ForLoopGhostIteratorNew./GhostIter_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!pervasive.ForLoopGhostIteratorNew./GhostIter_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!pervasive.ForLoopGhostIterator./ExecIter $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) $
   )
   :pattern ((proj%%vstd!pervasive.ForLoopGhostIterator./ExecIter $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj____vstd!pervasive.ForLoopGhostIterator./ExecIter_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!pervasive.ForLoopGhostIterator./ExecIter_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!pervasive.ForLoopGhostIterator./ExecIter $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) (TYPE%core!ops.range.Range. A&. A&)
   )
   :pattern ((proj%vstd!pervasive.ForLoopGhostIterator./ExecIter $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj__vstd!pervasive.ForLoopGhostIterator./ExecIter_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!pervasive.ForLoopGhostIterator./ExecIter_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!pervasive.ForLoopGhostIterator./Item $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) A&.
   )
   :pattern ((proj%%vstd!pervasive.ForLoopGhostIterator./Item $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj____vstd!pervasive.ForLoopGhostIterator./Item_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!pervasive.ForLoopGhostIterator./Item_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!pervasive.ForLoopGhostIterator./Item $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) A&
   )
   :pattern ((proj%vstd!pervasive.ForLoopGhostIterator./Item $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj__vstd!pervasive.ForLoopGhostIterator./Item_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!pervasive.ForLoopGhostIterator./Item_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!pervasive.ForLoopGhostIterator./Decrease $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) $
   )
   :pattern ((proj%%vstd!pervasive.ForLoopGhostIterator./Decrease $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj____vstd!pervasive.ForLoopGhostIterator./Decrease_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!pervasive.ForLoopGhostIterator./Decrease_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!pervasive.ForLoopGhostIterator./Decrease $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) INT
   )
   :pattern ((proj%vstd!pervasive.ForLoopGhostIterator./Decrease $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj__vstd!pervasive.ForLoopGhostIterator./Decrease_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!pervasive.ForLoopGhostIterator./Decrease_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    $
   )
   :pattern ((proj%%vstd!view.View./V $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    (TYPE%vstd!seq.Seq. A&. A&)
   )
   :pattern ((proj%vstd!view.View./V $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&.
      A&
   )))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 16) $ (UINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 16) $ (UINT 16)) (UINT 16))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 16) (REF $) (UINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 16) (REF $) (UINT 16)) (UINT 16))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 32) $ (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 32) $ (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 32) (REF $) (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 32) (REF $) (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (SINT 8) $ (SINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (SINT 8) $ (SINT 8)) (SINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (SINT 8) (REF $) (SINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (SINT 8) (REF $) (SINT 8)) (SINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (SINT 16) $ (SINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (SINT 16) $ (SINT 16)) (SINT 16))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (SINT 16) (REF $) (SINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (SINT 16) (REF $) (SINT 16)) (SINT 16))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 16) $ (UINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 16) $ (UINT 16)) (UINT 16))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 16) (REF $) (UINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 16) (REF $) (UINT 16)) (UINT 16))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 32) $ (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 32) $ (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 32) (REF $) (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 32) (REF $) (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (SINT 8) $ (SINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (SINT 8) $ (SINT 8)) (SINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (SINT 8) (REF $) (SINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (SINT 8) (REF $) (SINT 8)) (SINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (SINT 16) $ (SINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (SINT 16) $ (SINT 16)) (SINT 16))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (SINT 16) (REF $) (SINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (SINT 16) (REF $) (SINT 16)) (SINT 16))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%%core!ops.index.Index./Output $ (ARRAY T&. T& N&. N&) I&. I&) (proj%%core!ops.index.Index./Output
     $slice (SLICE T&. T&) I&. I&
   ))
   :pattern ((proj%%core!ops.index.Index./Output $ (ARRAY T&. T& N&. N&) I&. I&))
   :qid internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%core!ops.index.Index./Output $ (ARRAY T&. T& N&. N&) I&. I&) (proj%core!ops.index.Index./Output
     $slice (SLICE T&. T&) I&. I&
   ))
   :pattern ((proj%core!ops.index.Index./Output $ (ARRAY T&. T& N&. N&) I&. I&))
   :qid internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type)) (!
   (= (proj%%core!ops.index.Index./Output $slice (SLICE T&. T&) I&. I&) (proj%%core!slice.index.SliceIndex./Output
     I&. I& $slice (SLICE T&. T&)
   ))
   :pattern ((proj%%core!ops.index.Index./Output $slice (SLICE T&. T&) I&. I&))
   :qid internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type)) (!
   (= (proj%core!ops.index.Index./Output $slice (SLICE T&. T&) I&. I&) (proj%core!slice.index.SliceIndex./Output
     I&. I& $slice (SLICE T&. T&)
   ))
   :pattern ((proj%core!ops.index.Index./Output $slice (SLICE T&. T&) I&. I&))
   :qid internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
)))
(assert
 (forall ((I&. Dcr) (I& Type)) (!
   (= (proj%%core!ops.index.Index./Output $slice STRSLICE I&. I&) (proj%%core!slice.index.SliceIndex./Output
     I&. I& $slice STRSLICE
   ))
   :pattern ((proj%%core!ops.index.Index./Output $slice STRSLICE I&. I&))
   :qid internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
)))
(assert
 (forall ((I&. Dcr) (I& Type)) (!
   (= (proj%core!ops.index.Index./Output $slice STRSLICE I&. I&) (proj%core!slice.index.SliceIndex./Output
     I&. I& $slice STRSLICE
   ))
   :pattern ((proj%core!ops.index.Index./Output $slice STRSLICE I&. I&))
   :qid internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%core!iter.traits.iterator.Iterator./Item $ (TYPE%core!ops.range.Range. A&.
      A&
     )
    ) A&.
   )
   :pattern ((proj%%core!iter.traits.iterator.Iterator./Item $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_proj____core!iter.traits.iterator.Iterator./Item_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!iter.traits.iterator.Iterator./Item_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%core!iter.traits.iterator.Iterator./Item $ (TYPE%core!ops.range.Range. A&.
      A&
     )
    ) A&
   )
   :pattern ((proj%core!iter.traits.iterator.Iterator./Item $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_proj__core!iter.traits.iterator.Iterator./Item_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!iter.traits.iterator.Iterator./Item_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%core!slice.index.SliceIndex./Output $ USIZE $slice (SLICE T&. T&)) T&.)
   :pattern ((proj%%core!slice.index.SliceIndex./Output $ USIZE $slice (SLICE T&. T&)))
   :qid internal_proj____core!slice.index.SliceIndex./Output_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!slice.index.SliceIndex./Output_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%core!slice.index.SliceIndex./Output $ USIZE $slice (SLICE T&. T&)) T&)
   :pattern ((proj%core!slice.index.SliceIndex./Output $ USIZE $slice (SLICE T&. T&)))
   :qid internal_proj__core!slice.index.SliceIndex./Output_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!slice.index.SliceIndex./Output_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $ USIZE)
     $slice (SLICE T&. T&)
    ) $slice
   )
   :pattern ((proj%%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $
      USIZE
     ) $slice (SLICE T&. T&)
   ))
   :qid internal_proj____core!slice.index.SliceIndex./Output_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!slice.index.SliceIndex./Output_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $ USIZE)
     $slice (SLICE T&. T&)
    ) (SLICE T&. T&)
   )
   :pattern ((proj%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $
      USIZE
     ) $slice (SLICE T&. T&)
   ))
   :qid internal_proj__core!slice.index.SliceIndex./Output_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!slice.index.SliceIndex./Output_assoc_type_impl_false_definition
)))
(assert
 (= (proj%%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $ USIZE)
   $slice STRSLICE
  ) $slice
))
(assert
 (= (proj%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $ USIZE)
   $slice STRSLICE
  ) STRSLICE
))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  ) TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
  ) TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))
(assert
 (= (proj%%core!ops.arith.Add./Output $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (
    REF $
   ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))
(assert
 (= (proj%%core!ops.arith.Add./Output $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
   $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $
   TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Function-Decl vstd::seq::Seq::len
(declare-fun vstd!seq.Seq.len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::seq::Seq::index
(declare-fun vstd!seq.Seq.index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::spec_index
(declare-fun vstd!seq.impl&%0.spec_index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::new
(declare-fun vstd!seq.Seq.new.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::update
(declare-fun vstd!seq.Seq.update.? (Dcr Type Poly Poly Poly) Poly)

;; Function-Decl vstd::slice::spec_slice_len
(declare-fun vstd!slice.spec_slice_len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::view::View::view
(declare-fun vstd!view.View.view.? (Dcr Type Poly) Poly)
(declare-fun vstd!view.View.view%default%.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::slice::SliceAdditionalSpecFns::spec_index
(declare-fun vstd!slice.SliceAdditionalSpecFns.spec_index.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!slice.SliceAdditionalSpecFns.spec_index%default%.? (Dcr Type Dcr
  Type Poly Poly
 ) Poly
)

;; Function-Decl vstd::array::array_view
(declare-fun vstd!array.array_view.? (Dcr Type Dcr Type Poly) Poly)

;; Function-Decl vstd::array::ArrayAdditionalSpecFns::spec_index
(declare-fun vstd!array.ArrayAdditionalSpecFns.spec_index.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!array.ArrayAdditionalSpecFns.spec_index%default%.? (Dcr Type Dcr
  Type Poly Poly
 ) Poly
)

;; Function-Decl vstd::array::spec_array_as_slice
(declare-fun vstd!array.spec_array_as_slice.? (Dcr Type Dcr Type Poly) Poly)

;; Function-Decl vstd::array::spec_array_fill_for_copy_type
(declare-fun vstd!array.spec_array_fill_for_copy_type.? (Dcr Type Dcr Type Poly) %%Function%%)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq
(declare-fun vstd!raw_ptr.view_reverse_for_eq.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq_sized
(declare-fun vstd!raw_ptr.view_reverse_for_eq_sized.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::std_specs::range::StepSpec::spec_is_lt
(declare-fun vstd!std_specs.range.StepSpec.spec_is_lt.? (Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.range.StepSpec.spec_is_lt%default%.? (Dcr Type Poly Poly)
 Poly
)

;; Function-Decl vstd::std_specs::range::StepSpec::spec_steps_between_int
(declare-fun vstd!std_specs.range.StepSpec.spec_steps_between_int.? (Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!std_specs.range.StepSpec.spec_steps_between_int%default%.? (Dcr Type
  Poly Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::range::StepSpec::spec_forward_checked
(declare-fun vstd!std_specs.range.StepSpec.spec_forward_checked.? (Dcr Type Poly Poly)
 Poly
)
(declare-fun vstd!std_specs.range.StepSpec.spec_forward_checked%default%.? (Dcr Type
  Poly Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::range::StepSpec::spec_forward_checked_int
(declare-fun vstd!std_specs.range.StepSpec.spec_forward_checked_int.? (Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!std_specs.range.StepSpec.spec_forward_checked_int%default%.? (Dcr
  Type Poly Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::range::spec_range_next
(declare-fun vstd!std_specs.range.spec_range_next.? (Dcr Type Poly) tuple%2.)

;; Function-Decl vstd::std_specs::core::IndexSetTrustedSpec::spec_index_set_requires
(declare-fun vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? (Dcr
  Type Dcr Type Poly Poly
 ) Poly
)
(declare-fun vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires%default%.?
 (Dcr Type Dcr Type Poly Poly) Poly
)

;; Function-Decl vstd::std_specs::core::IndexSetTrustedSpec::spec_index_set_ensures
(declare-fun vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? (Dcr
  Type Dcr Type Poly Poly Poly Poly
 ) Poly
)
(declare-fun vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures%default%.?
 (Dcr Type Dcr Type Poly Poly Poly Poly) Poly
)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl vstd::pervasive::strictly_cloned
(declare-fun vstd!pervasive.strictly_cloned.? (Dcr Type Poly Poly) Bool)

;; Function-Decl vstd::pervasive::cloned
(declare-fun vstd!pervasive.cloned.? (Dcr Type Poly Poly) Bool)

;; Function-Decl vstd::std_specs::convert::FromSpec::obeys_from_spec
(declare-fun vstd!std_specs.convert.FromSpec.obeys_from_spec.? (Dcr Type Dcr Type)
 Poly
)
(declare-fun vstd!std_specs.convert.FromSpec.obeys_from_spec%default%.? (Dcr Type Dcr
  Type
 ) Poly
)

;; Function-Decl vstd::std_specs::convert::FromSpec::from_spec
(declare-fun vstd!std_specs.convert.FromSpec.from_spec.? (Dcr Type Dcr Type Poly)
 Poly
)
(declare-fun vstd!std_specs.convert.FromSpec.from_spec%default%.? (Dcr Type Dcr Type
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::AddSpec::add_req
(declare-fun vstd!std_specs.ops.AddSpec.add_req.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.AddSpec.add_req%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::AddSpec::obeys_add_spec
(declare-fun vstd!std_specs.ops.AddSpec.obeys_add_spec.? (Dcr Type Dcr Type) Poly)
(declare-fun vstd!std_specs.ops.AddSpec.obeys_add_spec%default%.? (Dcr Type Dcr Type)
 Poly
)

;; Function-Decl vstd::std_specs::ops::AddSpec::add_spec
(declare-fun vstd!std_specs.ops.AddSpec.add_spec.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.AddSpec.add_spec%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::option::OptionAdditionalFns::arrow_0
(declare-fun vstd!std_specs.option.OptionAdditionalFns.arrow_0.? (Dcr Type Dcr Type
  Poly
 ) Poly
)
(declare-fun vstd!std_specs.option.OptionAdditionalFns.arrow_0%default%.? (Dcr Type
  Dcr Type Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::option::is_some
(declare-fun vstd!std_specs.option.is_some.? (Dcr Type Poly) Bool)

;; Function-Decl vstd::std_specs::option::is_none
(declare-fun vstd!std_specs.option.is_none.? (Dcr Type Poly) Bool)

;; Function-Decl vstd::std_specs::option::spec_unwrap
(declare-fun vstd!std_specs.option.spec_unwrap.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::std_specs::option::spec_unwrap_or
(declare-fun vstd!std_specs.option.spec_unwrap_or.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::pervasive::FnWithRequiresEnsures::ensures
(declare-fun vstd!pervasive.FnWithRequiresEnsures.ensures.? (Dcr Type Dcr Type Dcr
  Type Poly Poly Poly
 ) Poly
)
(declare-fun vstd!pervasive.FnWithRequiresEnsures.ensures%default%.? (Dcr Type Dcr
  Type Dcr Type Poly Poly Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::exec_invariant
(declare-fun vstd!pervasive.ForLoopGhostIterator.exec_invariant.? (Dcr Type Poly Poly)
 Poly
)
(declare-fun vstd!pervasive.ForLoopGhostIterator.exec_invariant%default%.? (Dcr Type
  Poly Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::ghost_invariant
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? (Dcr Type Poly Poly)
 Poly
)
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_invariant%default%.? (Dcr Type
  Poly Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::ghost_ensures
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? (Dcr Type Poly) Poly)
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_ensures%default%.? (Dcr Type
  Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::ghost_decrease
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_decrease.? (Dcr Type Poly)
 Poly
)
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_decrease%default%.? (Dcr Type
  Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::ghost_peek_next
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.? (Dcr Type Poly)
 Poly
)
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_peek_next%default%.? (Dcr Type
  Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::ghost_advance
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_advance.? (Dcr Type Poly Poly)
 Poly
)
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_advance%default%.? (Dcr Type
  Poly Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIteratorNew::ghost_iter
(declare-fun vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? (Dcr Type Poly) Poly)
(declare-fun vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter%default%.? (Dcr Type
  Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::arbitrary
(declare-fun vstd!pervasive.arbitrary.? (Dcr Type) Poly)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::p
(declare-fun curve25519_dalek!specs.field_specs_u64.p.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::field_canonical
(declare-fun curve25519_dalek!specs.field_specs_u64.field_canonical.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::u64_5_as_nat
(declare-fun curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::u64_5_as_field_canonical
(declare-fun curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_as_canonical_nat
(declare-fun curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_x
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_x.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_y
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_y.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_z
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_z.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_t
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_t.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_point_as_nat
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? (Poly) tuple%4.)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_gcd
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?
 (Poly Poly) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
 (Poly Poly Fuel) Int
)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_extended_gcd
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
 (Poly Poly) curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
 (Poly Poly Fuel) curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_mod_inverse
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
 (Poly Poly) Int
)

;; Function-Decl curve25519_dalek::specs::field_specs::field_inv
(declare-fun curve25519_dalek!specs.field_specs.field_inv.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_mul
(declare-fun curve25519_dalek!specs.field_specs.field_mul.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_point_as_affine
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (Poly)
 tuple%2.
)

;; Function-Decl curve25519_dalek::backend::serial::u64::subtle_assumes::choice_is_true
(declare-fun curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (
  Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::field_specs::u64_5_bounded
(declare-fun curve25519_dalek!specs.field_specs.u64_5_bounded.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_limbs_bounded
(declare-fun curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::mask51
(declare-fun curve25519_dalek!specs.field_specs_u64.mask51.? () Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::spec_reduce
(declare-fun curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::sixteen_p_vec
(declare-fun curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.? () %%Function%%)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::pre_reduce_limbs
(declare-fun curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::spec_negate
(declare-fun curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::edwards_specs::negate_affine_niels
(declare-fun curve25519_dalek!specs.edwards_specs.negate_affine_niels.? (Poly) curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::negate_projective_niels
(declare-fun curve25519_dalek!specs.edwards_specs.negate_projective_niels.? (Poly)
 curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::EDWARDS_D
(declare-fun curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::field_specs::field_square
(declare-fun curve25519_dalek!specs.field_specs.field_square.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_sub
(declare-fun curve25519_dalek!specs.field_specs.field_sub.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_add
(declare-fun curve25519_dalek!specs.field_specs.field_add.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_on_edwards_curve_projective
(declare-fun curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.?
 (Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_extended_edwards_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.?
 (Poly Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_edwards_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_point_limbs_bounded
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::field_specs::sum_of_limbs_bounded
(declare-fun curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_well_formed_edwards_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? (
  Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_identity
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_identity.? (Poly) tuple%2.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_add
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_add.? (Poly Poly Poly Poly)
 tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_double
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_double.? (Poly Poly) tuple%2.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_scalar_mul
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly Poly)
 tuple%2.
)
(declare-fun curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? (Poly Poly
  Fuel
 ) tuple%2.
)

;; Function-Decl vstd::std_specs::core::iter_into_iter_spec
(declare-fun vstd!std_specs.core.iter_into_iter_spec.? (Dcr Type Poly) Poly)

;; Function-Decl curve25519_dalek::specs::field_specs::spec_add_fe51_limbs
(declare-fun curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? (Poly Poly)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::projective_niels_point_as_affine_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
 (Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::projective_niels_corresponds_to_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_projective_niels_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::is_valid_naf_lookup_table5_projective
(declare-fun curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::naf_lookup_table5_projective_limbs_bounded
(declare-fun curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::is_valid_lookup_table_projective
(declare-fun curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.?
 (Dcr Type Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::lookup_table_projective_limbs_bounded
(declare-fun curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.?
 (Dcr Type Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_z_sum_bounded
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.? (Poly) Bool)

;; Function-Decl curve25519_dalek::specs::edwards_specs::affine_niels_corresponds_to_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_affine_niels_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::affine_niels_point_as_affine_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?
 (Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::window_specs::is_valid_lookup_table_affine_coords
(declare-fun curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.?
 (Dcr Type Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::lookup_table_affine_limbs_bounded
(declare-fun curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.?
 (Dcr Type Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_on_edwards_curve
(declare-fun curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_identity_edwards_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::completed_point_as_nat
(declare-fun curve25519_dalek!specs.edwards_specs.completed_point_as_nat.? (Poly)
 tuple%4.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::completed_point_as_affine_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?
 (Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::identity_affine_niels
(declare-fun curve25519_dalek!specs.edwards_specs.identity_affine_niels.? (Poly) curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::identity_projective_niels
(declare-fun curve25519_dalek!specs.edwards_specs.identity_projective_niels.? (Poly)
 curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_completed_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::completed_to_extended
(declare-fun curve25519_dalek!specs.edwards_specs.completed_to_extended.? (Poly) tuple%4.)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_as_nat
(declare-fun curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::window_specs::is_valid_lookup_table_affine
(declare-fun curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.? (Dcr
  Type Poly Poly Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::naf_lookup_table5_affine_limbs_bounded
(declare-fun curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::is_valid_naf_lookup_table5_affine
(declare-fun curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::naf_lookup_table8_projective_limbs_bounded
(declare-fun curve25519_dalek!specs.window_specs.naf_lookup_table8_projective_limbs_bounded.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::naf_lookup_table8_affine_limbs_bounded
(declare-fun curve25519_dalek!specs.window_specs.naf_lookup_table8_affine_limbs_bounded.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::is_valid_naf_lookup_table8_projective
(declare-fun curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_projective.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::is_valid_naf_lookup_table8_affine
(declare-fun curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_affine.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::edwards::EdwardsPoint::well_formed
(declare-fun curve25519_dalek!edwards.impl&%15.well_formed.? (Poly) Bool)

;; Function-Axioms vstd::seq::Seq::len
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
    (<= 0 (vstd!seq.Seq.len.? A&. A& self!))
   )
   :pattern ((vstd!seq.Seq.len.? A&. A& self!))
   :qid internal_vstd!seq.Seq.len.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.len.?_pre_post_definition
)))

;; Function-Specs vstd::seq::Seq::index
(declare-fun req%vstd!seq.Seq.index. (Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%0 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (= (req%vstd!seq.Seq.index. A&. A& self! i!) (=>
     %%global_location_label%%0
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? A&. A& self!))
   ))))
   :pattern ((req%vstd!seq.Seq.index. A&. A& self! i!))
   :qid internal_req__vstd!seq.Seq.index._definition
   :skolemid skolem_internal_req__vstd!seq.Seq.index._definition
)))

;; Function-Axioms vstd::seq::Seq::index
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
    )
    (has_type (vstd!seq.Seq.index.? A&. A& self! i!) A&)
   )
   :pattern ((vstd!seq.Seq.index.? A&. A& self! i!))
   :qid internal_vstd!seq.Seq.index.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.index.?_pre_post_definition
)))

;; Function-Specs vstd::seq::impl&%0::spec_index
(declare-fun req%vstd!seq.impl&%0.spec_index. (Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%1 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (= (req%vstd!seq.impl&%0.spec_index. A&. A& self! i!) (=>
     %%global_location_label%%1
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? A&. A& self!))
   ))))
   :pattern ((req%vstd!seq.impl&%0.spec_index. A&. A& self! i!))
   :qid internal_req__vstd!seq.impl&__0.spec_index._definition
   :skolemid skolem_internal_req__vstd!seq.impl&__0.spec_index._definition
)))

;; Function-Axioms vstd::seq::impl&%0::spec_index
(assert
 (fuel_bool_default fuel%vstd!seq.impl&%0.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!seq.impl&%0.spec_index.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
    (= (vstd!seq.impl&%0.spec_index.? A&. A& self! i!) (vstd!seq.Seq.index.? A&. A& self!
      i!
    ))
    :pattern ((vstd!seq.impl&%0.spec_index.? A&. A& self! i!))
    :qid internal_vstd!seq.impl&__0.spec_index.?_definition
    :skolemid skolem_internal_vstd!seq.impl&__0.spec_index.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
    )
    (has_type (vstd!seq.impl&%0.spec_index.? A&. A& self! i!) A&)
   )
   :pattern ((vstd!seq.impl&%0.spec_index.? A&. A& self! i!))
   :qid internal_vstd!seq.impl&__0.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.impl&__0.spec_index.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_index_decreases
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_index_decreases.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
      )))
      (height_lt (height (vstd!seq.Seq.index.? A&. A& s! i!)) (height s!))
    ))
    :pattern ((height (vstd!seq.Seq.index.? A&. A& s! i!)))
    :qid user_vstd__seq__axiom_seq_index_decreases_0
    :skolemid skolem_user_vstd__seq__axiom_seq_index_decreases_0
))))

;; Function-Axioms vstd::seq::Seq::new
(assert
 (forall ((A&. Dcr) (A& Type) (impl%1&. Dcr) (impl%1& Type) (len! Poly) (f! Poly))
  (!
   (=>
    (and
     (has_type len! NAT)
     (has_type f! impl%1&)
    )
    (has_type (vstd!seq.Seq.new.? A&. A& impl%1&. impl%1& len! f!) (TYPE%vstd!seq.Seq.
      A&. A&
   )))
   :pattern ((vstd!seq.Seq.new.? A&. A& impl%1&. impl%1& len! f!))
   :qid internal_vstd!seq.Seq.new.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.new.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_new_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_new_len.)
  (forall ((A&. Dcr) (A& Type) (len! Poly) (f! Poly)) (!
    (=>
     (and
      (has_type len! NAT)
      (has_type f! (TYPE%fun%1. $ INT A&. A&))
     )
     (=>
      (sized A&.)
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&)
         len! f!
        )
       ) (%I len!)
    )))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT
        A&. A&
       ) len! f!
    )))
    :qid user_vstd__seq__axiom_seq_new_len_1
    :skolemid skolem_user_vstd__seq__axiom_seq_new_len_1
))))

;; Broadcast vstd::seq::axiom_seq_new_index
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_new_index.)
  (forall ((A&. Dcr) (A& Type) (len! Poly) (f! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type len! NAT)
      (has_type f! (TYPE%fun%1. $ INT A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (%I len!))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&)
         len! f!
        ) i!
       ) (%%apply%%0 (%Poly%fun%1. f!) i!)
    )))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT
        A&. A&
       ) len! f!
      ) i!
    ))
    :qid user_vstd__seq__axiom_seq_new_index_2
    :skolemid skolem_user_vstd__seq__axiom_seq_new_index_2
))))

;; Function-Specs vstd::seq::Seq::update
(declare-fun req%vstd!seq.Seq.update. (Dcr Type Poly Poly Poly) Bool)
(declare-const %%global_location_label%%2 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly) (a! Poly)) (!
   (= (req%vstd!seq.Seq.update. A&. A& self! i! a!) (=>
     %%global_location_label%%2
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? A&. A& self!))
   ))))
   :pattern ((req%vstd!seq.Seq.update. A&. A& self! i! a!))
   :qid internal_req__vstd!seq.Seq.update._definition
   :skolemid skolem_internal_req__vstd!seq.Seq.update._definition
)))

;; Function-Axioms vstd::seq::Seq::update
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly) (a! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
     (has_type a! A&)
    )
    (has_type (vstd!seq.Seq.update.? A&. A& self! i! a!) (TYPE%vstd!seq.Seq. A&. A&))
   )
   :pattern ((vstd!seq.Seq.update.? A&. A& self! i! a!))
   :qid internal_vstd!seq.Seq.update.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.update.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_update_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_update_len.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly) (a! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
      (has_type a! A&)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
      )))
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i! a!)) (vstd!seq.Seq.len.?
        A&. A& s!
    ))))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i! a!)))
    :qid user_vstd__seq__axiom_seq_update_len_3
    :skolemid skolem_user_vstd__seq__axiom_seq_update_len_3
))))

;; Broadcast vstd::seq::axiom_seq_update_same
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_update_same.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly) (a! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
      (has_type a! A&)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i! a!) i!) a!)
    ))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i! a!) i!))
    :qid user_vstd__seq__axiom_seq_update_same_4
    :skolemid skolem_user_vstd__seq__axiom_seq_update_same_4
))))

;; Broadcast vstd::seq::axiom_seq_update_different
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_update_different.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i1! Poly) (i2! Poly) (a! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i1! INT)
      (has_type i2! INT)
      (has_type a! A&)
     )
     (=>
      (and
       (and
        (and
         (sized A&.)
         (let
          ((tmp%%$ (%I i1!)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
        )))
        (let
         ((tmp%%$ (%I i2!)))
         (and
          (<= 0 tmp%%$)
          (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
       )))
       (not (= i1! i2!))
      )
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i2! a!) i1!) (vstd!seq.Seq.index.?
        A&. A& s! i1!
    ))))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i2! a!) i1!))
    :qid user_vstd__seq__axiom_seq_update_different_5
    :skolemid skolem_user_vstd__seq__axiom_seq_update_different_5
))))

;; Broadcast vstd::seq::axiom_seq_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_ext_equal.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (=>
      (sized A&.)
      (= (ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!) (and
        (= (vstd!seq.Seq.len.? A&. A& s1!) (vstd!seq.Seq.len.? A&. A& s2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s1!))
            ))
            (= (vstd!seq.Seq.index.? A&. A& s1! i$) (vstd!seq.Seq.index.? A&. A& s2! i$))
          ))
          :pattern ((vstd!seq.Seq.index.? A&. A& s1! i$))
          :pattern ((vstd!seq.Seq.index.? A&. A& s2! i$))
          :qid user_vstd__seq__axiom_seq_ext_equal_6
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_6
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_7
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_7
))))

;; Broadcast vstd::seq::axiom_seq_ext_equal_deep
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_ext_equal_deep.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (=>
      (sized A&.)
      (= (ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!) (and
        (= (vstd!seq.Seq.len.? A&. A& s1!) (vstd!seq.Seq.len.? A&. A& s2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s1!))
            ))
            (ext_eq true A& (vstd!seq.Seq.index.? A&. A& s1! i$) (vstd!seq.Seq.index.? A&. A& s2!
              i$
          ))))
          :pattern ((vstd!seq.Seq.index.? A&. A& s1! i$))
          :pattern ((vstd!seq.Seq.index.? A&. A& s2! i$))
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_8
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_8
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_9
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_9
))))

;; Function-Axioms vstd::slice::spec_slice_len
(assert
 (forall ((T&. Dcr) (T& Type) (slice! Poly)) (!
   (=>
    (has_type slice! (SLICE T&. T&))
    (uInv SZ (vstd!slice.spec_slice_len.? T&. T& slice!))
   )
   :pattern ((vstd!slice.spec_slice_len.? T&. T& slice!))
   :qid internal_vstd!slice.spec_slice_len.?_pre_post_definition
   :skolemid skolem_internal_vstd!slice.spec_slice_len.?_pre_post_definition
)))

;; Function-Axioms vstd::view::View::view
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!view.View.view.? Self%&. Self%& self!) (proj%vstd!view.View./V Self%&.
      Self%&
   )))
   :pattern ((vstd!view.View.view.? Self%&. Self%& self!))
   :qid internal_vstd!view.View.view.?_pre_post_definition
   :skolemid skolem_internal_vstd!view.View.view.?_pre_post_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!view.View. $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%vstd!view.View. $slice (SLICE T&. T&)))
   :qid internal_vstd__slice__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__slice__impl&__0_trait_impl_definition
)))

;; Broadcast vstd::slice::axiom_spec_len
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_spec_len.)
  (forall ((T&. Dcr) (T& Type) (slice! Poly)) (!
    (=>
     (has_type slice! (SLICE T&. T&))
     (=>
      (sized T&.)
      (= (vstd!slice.spec_slice_len.? T&. T& slice!) (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.?
         $slice (SLICE T&. T&) slice!
    )))))
    :pattern ((vstd!slice.spec_slice_len.? T&. T& slice!))
    :qid user_vstd__slice__axiom_spec_len_10
    :skolemid skolem_user_vstd__slice__axiom_spec_len_10
))))

;; Function-Specs vstd::slice::SliceAdditionalSpecFns::spec_index
(declare-fun req%vstd!slice.SliceAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%3 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%3
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? Self%&. Self%& self!)))
   ))))
   :pattern ((req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T&
     self! i!
   ))
   :qid internal_req__vstd!slice.SliceAdditionalSpecFns.spec_index._definition
   :skolemid skolem_internal_req__vstd!slice.SliceAdditionalSpecFns.spec_index._definition
)))

;; Function-Axioms vstd::slice::SliceAdditionalSpecFns::spec_index
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (=>
    (and
     (has_type self! Self%&)
     (has_type i! INT)
    )
    (has_type (vstd!slice.SliceAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
      i!
     ) T&
   ))
   :pattern ((vstd!slice.SliceAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
     i!
   ))
   :qid internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_pre_post_definition
)))

;; Function-Axioms vstd::slice::impl&%2::spec_index
(assert
 (fuel_bool_default fuel%vstd!slice.impl&%2.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!slice.impl&%2.spec_index.)
  (forall ((T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!slice.SliceAdditionalSpecFns.spec_index.? $slice (SLICE T&. T&) T&. T& self!
       i!
      ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) self!)
       i!
    )))
    :pattern ((vstd!slice.SliceAdditionalSpecFns.spec_index.? $slice (SLICE T&. T&) T&.
      T& self! i!
    ))
    :qid internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_definition
    :skolemid skolem_internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!slice.SliceAdditionalSpecFns. $slice (SLICE T&. T&) T&. T&)
   )
   :pattern ((tr_bound%vstd!slice.SliceAdditionalSpecFns. $slice (SLICE T&. T&) T&. T&))
   :qid internal_vstd__slice__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__slice__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::slice::axiom_slice_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_slice_ext_equal.)
  (forall ((T&. Dcr) (T& Type) (a1! Poly) (a2! Poly)) (!
    (=>
     (and
      (has_type a1! (SLICE T&. T&))
      (has_type a2! (SLICE T&. T&))
     )
     (=>
      (sized T&.)
      (= (ext_eq false (SLICE T&. T&) a1! a2!) (and
        (= (vstd!slice.spec_slice_len.? T&. T& a1!) (vstd!slice.spec_slice_len.? T&. T& a2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!slice.spec_slice_len.? T&. T& a1!))
            ))
            (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) a1!) i$)
             (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) a2!) i$)
          )))
          :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&)
             a1!
            ) i$
          ))
          :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&)
             a2!
            ) i$
          ))
          :qid user_vstd__slice__axiom_slice_ext_equal_11
          :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_11
    ))))))
    :pattern ((ext_eq false (SLICE T&. T&) a1! a2!))
    :qid user_vstd__slice__axiom_slice_ext_equal_12
    :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_12
))))

;; Broadcast vstd::slice::axiom_slice_has_resolved
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_slice_has_resolved.)
  (forall ((T&. Dcr) (T& Type) (slice! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type slice! (SLICE T&. T&))
      (has_type i! INT)
     )
     (=>
      (sized T&.)
      (=>
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!slice.spec_slice_len.? T&. T& slice!))
       ))
       (=>
        (has_resolved $slice (SLICE T&. T&) slice!)
        (has_resolved T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE
            T&. T&
           ) slice!
          ) i!
    ))))))
    :pattern ((has_resolved $slice (SLICE T&. T&) slice!) (vstd!seq.Seq.index.? T&. T&
      (vstd!view.View.view.? $slice (SLICE T&. T&) slice!) i!
    ))
    :qid user_vstd__slice__axiom_slice_has_resolved_13
    :skolemid skolem_user_vstd__slice__axiom_slice_has_resolved_13
))))

;; Function-Axioms vstd::array::array_view
(assert
 (fuel_bool_default fuel%vstd!array.array_view.)
)
(declare-fun %%lambda%%0 (Dcr Type Dcr Type %%Function%%) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Dcr) (%%hole%%3 Type) (%%hole%%4
    %%Function%%
   ) (i$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4) i$)
    (array_index %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 i$)
   )
   :pattern ((%%apply%%0 (%%lambda%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4)
     i$
)))))
(assert
 (=>
  (fuel_bool fuel%vstd!array.array_view.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly)) (!
    (= (vstd!array.array_view.? T&. T& N&. N& a!) (vstd!seq.Seq.new.? T&. T& $ (TYPE%fun%1.
       $ INT T&. T&
      ) (I (const_int N&)) (Poly%fun%1. (mk_fun (%%lambda%%0 T&. T& N&. N& (%Poly%array%. a!))))
    ))
    :pattern ((vstd!array.array_view.? T&. T& N&. N& a!))
    :qid internal_vstd!array.array_view.?_definition
    :skolemid skolem_internal_vstd!array.array_view.?_definition
))))
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly)) (!
   (=>
    (has_type a! (ARRAY T&. T& N&. N&))
    (has_type (vstd!array.array_view.? T&. T& N&. N& a!) (TYPE%vstd!seq.Seq. T&. T&))
   )
   :pattern ((vstd!array.array_view.? T&. T& N&. N& a!))
   :qid internal_vstd!array.array_view.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.array_view.?_pre_post_definition
)))

;; Function-Axioms vstd::array::impl&%0::view
(assert
 (fuel_bool_default fuel%vstd!array.impl&%0.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!array.impl&%0.view.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly)) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!) (vstd!array.array_view.? T&.
       T& N&. N& self!
    )))
    :pattern ((vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!view.View. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%vstd!view.View. $ (ARRAY T&. T& N&. N&)))
   :qid internal_vstd__array__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__array__impl&__0_trait_impl_definition
)))

;; Broadcast vstd::array::array_len_matches_n
(assert
 (=>
  (fuel_bool fuel%vstd!array.array_len_matches_n.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! Poly)) (!
    (=>
     (has_type ar! (ARRAY T&. T& N&. N&))
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (= (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) ar!))
       (const_int N&)
    )))
    :pattern ((vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
       ar!
    )))
    :qid user_vstd__array__array_len_matches_n_14
    :skolemid skolem_user_vstd__array__array_len_matches_n_14
))))

;; Function-Specs vstd::array::ArrayAdditionalSpecFns::spec_index
(declare-fun req%vstd!array.ArrayAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%4 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!array.ArrayAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%4
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? Self%&. Self%& self!)))
   ))))
   :pattern ((req%vstd!array.ArrayAdditionalSpecFns.spec_index. Self%&. Self%& T&. T&
     self! i!
   ))
   :qid internal_req__vstd!array.ArrayAdditionalSpecFns.spec_index._definition
   :skolemid skolem_internal_req__vstd!array.ArrayAdditionalSpecFns.spec_index._definition
)))

;; Function-Axioms vstd::array::ArrayAdditionalSpecFns::spec_index
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (=>
    (and
     (has_type self! Self%&)
     (has_type i! INT)
    )
    (has_type (vstd!array.ArrayAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
      i!
     ) T&
   ))
   :pattern ((vstd!array.ArrayAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
     i!
   ))
   :qid internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_pre_post_definition
)))

;; Function-Axioms vstd::array::impl&%2::spec_index
(assert
 (fuel_bool_default fuel%vstd!array.impl&%2.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!array.impl&%2.spec_index.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly) (i! Poly)) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!array.ArrayAdditionalSpecFns.spec_index.? $ (ARRAY T&. T& N&. N&) T&. T& self!
       i!
      ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!)
       i!
    )))
    :pattern ((vstd!array.ArrayAdditionalSpecFns.spec_index.? $ (ARRAY T&. T& N&. N&) T&.
      T& self! i!
    ))
    :qid internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_definition
    :skolemid skolem_internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!array.ArrayAdditionalSpecFns. $ (ARRAY T&. T& N&. N&) T&. T&)
   )
   :pattern ((tr_bound%vstd!array.ArrayAdditionalSpecFns. $ (ARRAY T&. T& N&. N&) T&.
     T&
   ))
   :qid internal_vstd__array__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__array__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::array::lemma_array_index
(assert
 (=>
  (fuel_bool fuel%vstd!array.lemma_array_index.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type a! (ARRAY T&. T& N&. N&))
      (has_type i! INT)
     )
     (=>
      (and
       (and
        (sized T&.)
        (uInv SZ (const_int N&))
       )
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (const_int N&))
      )))
      (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a!)
        i!
       ) (vstd!seq.Seq.index.? T&. T& (vstd!array.array_view.? T&. T& N&. N& a!) i!)
    )))
    :pattern ((array_index T&. T& N&. N& (%Poly%array%. a!) i!))
    :qid user_vstd__array__lemma_array_index_15
    :skolemid skolem_user_vstd__array__lemma_array_index_15
))))

;; Function-Axioms vstd::array::spec_array_as_slice
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! Poly)) (!
   (=>
    (has_type ar! (ARRAY T&. T& N&. N&))
    (has_type (vstd!array.spec_array_as_slice.? T&. T& N&. N& ar!) (SLICE T&. T&))
   )
   :pattern ((vstd!array.spec_array_as_slice.? T&. T& N&. N& ar!))
   :qid internal_vstd!array.spec_array_as_slice.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.spec_array_as_slice.?_pre_post_definition
)))

;; Broadcast vstd::array::axiom_spec_array_as_slice
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_spec_array_as_slice.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! Poly)) (!
    (=>
     (has_type ar! (ARRAY T&. T& N&. N&))
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (= (vstd!view.View.view.? $slice (SLICE T&. T&) (vstd!array.spec_array_as_slice.? T&.
         T& N&. N& ar!
        )
       ) (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) ar!)
    )))
    :pattern ((vstd!array.spec_array_as_slice.? T&. T& N&. N& ar!))
    :qid user_vstd__array__axiom_spec_array_as_slice_16
    :skolemid skolem_user_vstd__array__axiom_spec_array_as_slice_16
))))

;; Function-Axioms vstd::array::spec_array_fill_for_copy_type
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (t! Poly)) (!
   (=>
    (has_type t! T&)
    (has_type (Poly%array%. (vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!))
     (ARRAY T&. T& N&. N&)
   ))
   :pattern ((vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!))
   :qid internal_vstd!array.spec_array_fill_for_copy_type.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.spec_array_fill_for_copy_type.?_pre_post_definition
)))

;; Broadcast vstd::array::axiom_spec_array_fill_for_copy_type
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_spec_array_fill_for_copy_type.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (t! Poly)) (!
    (=>
     (has_type t! T&)
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (const_int N&))
          ))
          (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) (Poly%array%.
              (vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!)
             )
            ) i$
           ) t!
        )))
        :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
           (Poly%array%. (vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!))
          ) i$
        ))
        :qid user_vstd__array__axiom_spec_array_fill_for_copy_type_17
        :skolemid skolem_user_vstd__array__axiom_spec_array_fill_for_copy_type_17
    ))))
    :pattern ((vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!))
    :qid user_vstd__array__axiom_spec_array_fill_for_copy_type_18
    :skolemid skolem_user_vstd__array__axiom_spec_array_fill_for_copy_type_18
))))

;; Broadcast vstd::array::axiom_array_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_array_ext_equal.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a1! Poly) (a2! Poly)) (!
    (=>
     (and
      (has_type a1! (ARRAY T&. T& N&. N&))
      (has_type a2! (ARRAY T&. T& N&. N&))
     )
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (= (ext_eq false (ARRAY T&. T& N&. N&) a1! a2!) (forall ((i$ Poly)) (!
         (=>
          (has_type i$ INT)
          (=>
           (let
            ((tmp%%$ (%I i$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ (const_int N&))
           ))
           (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a1!)
             i$
            ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a2!)
             i$
         ))))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            a1!
           ) i$
         ))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            a2!
           ) i$
         ))
         :qid user_vstd__array__axiom_array_ext_equal_19
         :skolemid skolem_user_vstd__array__axiom_array_ext_equal_19
    )))))
    :pattern ((ext_eq false (ARRAY T&. T& N&. N&) a1! a2!))
    :qid user_vstd__array__axiom_array_ext_equal_20
    :skolemid skolem_user_vstd__array__axiom_array_ext_equal_20
))))

;; Broadcast vstd::array::axiom_array_has_resolved
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_array_has_resolved.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (array! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type array! (ARRAY T&. T& N&. N&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (=>
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (const_int N&))
       ))
       (=>
        (has_resolved $ (ARRAY T&. T& N&. N&) array!)
        (has_resolved T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&.
            T& N&. N&
           ) array!
          ) i!
    ))))))
    :pattern ((has_resolved $ (ARRAY T&. T& N&. N&) array!) (vstd!seq.Seq.index.? T&. T&
      (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) array!) i!
    ))
    :qid user_vstd__array__axiom_array_has_resolved_21
    :skolemid skolem_user_vstd__array__axiom_array_has_resolved_21
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $slice STRSLICE)
)

;; Broadcast vstd::string::axiom_str_literal_len
(assert
 (=>
  (fuel_bool fuel%vstd!string.axiom_str_literal_len.)
  (forall ((s! Poly)) (!
    (=>
     (has_type s! STRSLICE)
     (= (vstd!seq.Seq.len.? $ CHAR (vstd!view.View.view.? $slice STRSLICE s!)) (str%strslice_len
       (%Poly%strslice%. s!)
    )))
    :pattern ((vstd!seq.Seq.len.? $ CHAR (vstd!view.View.view.? $slice STRSLICE s!)))
    :qid user_vstd__string__axiom_str_literal_len_22
    :skolemid skolem_user_vstd__string__axiom_str_literal_len_22
))))

;; Broadcast vstd::string::axiom_str_literal_get_char
(assert
 (=>
  (fuel_bool fuel%vstd!string.axiom_str_literal_get_char.)
  (forall ((s! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! STRSLICE)
      (has_type i! INT)
     )
     (= (%I (vstd!seq.Seq.index.? $ CHAR (vstd!view.View.view.? $slice STRSLICE s!) i!))
      (str%strslice_get_char (%Poly%strslice%. s!) (%I i!))
    ))
    :pattern ((vstd!seq.Seq.index.? $ CHAR (vstd!view.View.view.? $slice STRSLICE s!) i!))
    :qid user_vstd__string__axiom_str_literal_get_char_23
    :skolemid skolem_user_vstd__string__axiom_str_literal_get_char_23
))))

;; Function-Axioms vstd::raw_ptr::view_reverse_for_eq
(assert
 (forall ((T&. Dcr) (T& Type) (data! Poly)) (!
   (=>
    (has_type data! (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (has_type (vstd!raw_ptr.view_reverse_for_eq.? T&. T& data!) (PTR T&. T&))
   )
   :pattern ((vstd!raw_ptr.view_reverse_for_eq.? T&. T& data!))
   :qid internal_vstd!raw_ptr.view_reverse_for_eq.?_pre_post_definition
   :skolemid skolem_internal_vstd!raw_ptr.view_reverse_for_eq.?_pre_post_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%vstd!view.View. $ (PTR T&. T&))
   :pattern ((tr_bound%vstd!view.View. $ (PTR T&. T&)))
   :qid internal_vstd__raw_ptr__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__raw_ptr__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::raw_ptr::ptrs_mut_eq
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.ptrs_mut_eq.)
  (forall ((T&. Dcr) (T& Type) (a! Poly)) (!
    (=>
     (has_type a! (PTR T&. T&))
     (= (vstd!raw_ptr.view_reverse_for_eq.? T&. T& (vstd!view.View.view.? $ (PTR T&. T&)
        a!
       )
      ) a!
    ))
    :pattern ((vstd!view.View.view.? $ (PTR T&. T&) a!))
    :qid user_vstd__raw_ptr__ptrs_mut_eq_24
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_24
))))

;; Function-Axioms vstd::raw_ptr::view_reverse_for_eq_sized
(assert
 (forall ((T&. Dcr) (T& Type) (addr! Poly) (provenance! Poly)) (!
   (=>
    (and
     (has_type addr! USIZE)
     (has_type provenance! TYPE%vstd!raw_ptr.Provenance.)
    )
    (has_type (vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& addr! provenance!) (PTR
      T&. T&
   )))
   :pattern ((vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& addr! provenance!))
   :qid internal_vstd!raw_ptr.view_reverse_for_eq_sized.?_pre_post_definition
   :skolemid skolem_internal_vstd!raw_ptr.view_reverse_for_eq_sized.?_pre_post_definition
)))

;; Broadcast vstd::raw_ptr::ptrs_mut_eq_sized
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.ptrs_mut_eq_sized.)
  (forall ((T&. Dcr) (T& Type) (a! Poly)) (!
    (=>
     (has_type a! (PTR T&. T&))
     (=>
      (sized T&.)
      (= (vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& (I (vstd!raw_ptr.PtrData./PtrData/addr
          (%Poly%vstd!raw_ptr.PtrData. (vstd!view.View.view.? $ (PTR T&. T&) a!))
         )
        ) (Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.PtrData./PtrData/provenance (%Poly%vstd!raw_ptr.PtrData.
           (vstd!view.View.view.? $ (PTR T&. T&) a!)
        )))
       ) a!
    )))
    :pattern ((vstd!view.View.view.? $ (PTR T&. T&) a!))
    :qid user_vstd__raw_ptr__ptrs_mut_eq_sized_25
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_sized_25
))))

;; Function-Axioms vstd::std_specs::range::StepSpec::spec_is_lt
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (other! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type other! Self%&)
    )
    (has_type (vstd!std_specs.range.StepSpec.spec_is_lt.? Self%&. Self%& self! other!)
     BOOL
   ))
   :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? Self%&. Self%& self! other!))
   :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::StepSpec::spec_steps_between_int
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (end! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type end! Self%&)
    )
    (has_type (vstd!std_specs.range.StepSpec.spec_steps_between_int.? Self%&. Self%& self!
      end!
     ) INT
   ))
   :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? Self%&. Self%& self!
     end!
   ))
   :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::StepSpec::spec_forward_checked
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (count! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type count! USIZE)
    )
    (has_type (vstd!std_specs.range.StepSpec.spec_forward_checked.? Self%&. Self%& self!
      count!
     ) (TYPE%core!option.Option. Self%&. Self%&)
   ))
   :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? Self%&. Self%& self!
     count!
   ))
   :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::StepSpec::spec_forward_checked_int
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (count! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type count! INT)
    )
    (has_type (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? Self%&. Self%&
      self! count!
     ) (TYPE%core!option.Option. Self%&. Self%&)
   ))
   :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? Self%&. Self%&
     self! count!
   ))
   :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::impl&%6::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%6.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%6.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 8) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 8) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%6::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%6.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%6.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 8) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 255)
       (core!option.Option./Some (I (uClip 8 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 8) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%6::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%6.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%6.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 8) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 8) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 8) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::spec_range_next
(assert
 (forall ((A&. Dcr) (A& Type) (a! Poly)) (!
   (=>
    (has_type a! (TYPE%core!ops.range.Range. A&. A&))
    (has_type (Poly%tuple%2. (vstd!std_specs.range.spec_range_next.? A&. A& a!)) (TYPE%tuple%2.
      $ (TYPE%core!ops.range.Range. A&. A&) $ (TYPE%core!option.Option. A&. A&)
   )))
   :pattern ((vstd!std_specs.range.spec_range_next.? A&. A& a!))
   :qid internal_vstd!std_specs.range.spec_range_next.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.range.spec_range_next.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::impl&%6::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%6.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%6.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 8) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 8) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (UINT 8))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_u8
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_u8.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (UINT 8)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 8) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (UINT 8) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (UINT 8) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (UINT 8) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 8) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (UINT 8) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (UINT 8) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_u8_26
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_u8_26
))))

;; Function-Axioms vstd::std_specs::range::impl&%7::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%7.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%7.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 16) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 16) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%7::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%7.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%7.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 16) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 65535)
       (core!option.Option./Some (I (uClip 16 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 16) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%7::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%7.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%7.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 16) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 16) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 16) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%7::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%7.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%7.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 16) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 16) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (UINT 16))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_u16
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_u16.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (UINT 16)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 16) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (UINT 16) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (UINT 16) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (UINT 16) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 16) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (UINT 16) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (UINT 16) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_u16_27
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_u16_27
))))

;; Function-Axioms vstd::std_specs::range::impl&%8::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%8.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%8.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 32) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 32) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%8::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%8.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%8.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 32) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 4294967295)
       (core!option.Option./Some (I (uClip 32 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 32) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%8::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%8.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%8.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 32) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 32) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 32) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%8::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%8.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%8.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 32) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 32) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (UINT 32))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_u32
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_u32.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (UINT 32)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 32) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (UINT 32) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (UINT 32) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (UINT 32) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 32) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (UINT 32) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (UINT 32) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_u32_28
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_u32_28
))))

;; Function-Axioms vstd::std_specs::range::impl&%9::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%9.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%9.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 64) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 64) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%9::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%9.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%9.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 64) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 18446744073709551615)
       (core!option.Option./Some (I (uClip 64 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 64) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%9::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%9.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%9.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 64) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 64) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 64) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%9::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%9.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%9.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 64) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 64) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (UINT 64))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_u64
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_u64.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (UINT 64)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 64) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (UINT 64) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (UINT 64) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (UINT 64) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 64) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (UINT 64) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (UINT 64) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_u64_29
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_u64_29
))))

;; Function-Axioms vstd::std_specs::range::impl&%11::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%11.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%11.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ USIZE self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ USIZE self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%11::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%11.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%11.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ USIZE self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) (- (uHi SZ) 1))
       (core!option.Option./Some (I (uClip SZ (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ USIZE self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%11::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%11.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%11.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ USIZE self! count!) (vstd!std_specs.range.StepSpec.spec_forward_checked_int.?
      $ USIZE self! count!
    ))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ USIZE self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%11::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%11.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%11.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ USIZE self! end!) (I (
       Sub (%I end!) (%I self!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ USIZE self! end!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ USIZE)
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_usize
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_usize.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ USIZE))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ USIZE (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ USIZE (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ USIZE range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ USIZE (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ USIZE range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ USIZE range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_usize_30
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_usize_30
))))

;; Function-Axioms vstd::std_specs::range::impl&%12::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%12.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%12.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 8) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 8) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%12::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%12.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%12.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (SINT 8) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 127)
       (core!option.Option./Some (I (iClip 8 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (SINT 8) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%12::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%12.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%12.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (SINT 8) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (SINT 8) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (SINT 8) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%12::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%12.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%12.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (SINT 8) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (SINT 8) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (SINT 8))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_i8
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_i8.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (SINT 8)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 8) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (SINT 8) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (SINT 8) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (SINT 8) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 8) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (SINT 8) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (SINT 8) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_i8_31
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_i8_31
))))

;; Function-Axioms vstd::std_specs::range::impl&%13::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%13.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%13.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 16) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 16) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%13::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%13.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%13.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (SINT 16) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 32767)
       (core!option.Option./Some (I (iClip 16 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (SINT 16) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%13::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%13.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%13.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (SINT 16) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (SINT 16) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (SINT 16) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%13::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%13.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%13.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (SINT 16) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (SINT 16) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (SINT 16))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_i16
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_i16.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (SINT 16)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 16) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (SINT 16) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (SINT 16) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (SINT 16) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 16) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (SINT 16) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (SINT 16) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_i16_32
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_i16_32
))))

;; Function-Axioms vstd::std_specs::range::impl&%14::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%14.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%14.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 32) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 32) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%14::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%14.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%14.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (SINT 32) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 2147483647)
       (core!option.Option./Some (I (iClip 32 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (SINT 32) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%14::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%14.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%14.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (SINT 32) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (SINT 32) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (SINT 32) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%14::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%14.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%14.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (SINT 32) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (SINT 32) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (SINT 32))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_i32
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_i32.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (SINT 32)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 32) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (SINT 32) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (SINT 32) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (SINT 32) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 32) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (SINT 32) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (SINT 32) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_i32_33
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_i32_33
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!alloc.Allocator. $ ALLOCATOR_GLOBAL)
)

;; Function-Specs core::clone::Clone::clone
(declare-fun ens%core!clone.Clone.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (%return! Poly)) (!
   (= (ens%core!clone.Clone.clone. Self%&. Self%& self! %return!) (has_type %return! Self%&))
   :pattern ((ens%core!clone.Clone.clone. Self%&. Self%& self! %return!))
   :qid internal_ens__core!clone.Clone.clone._definition
   :skolemid skolem_internal_ens__core!clone.Clone.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (Self%&. Dcr) (Self%& Type)) (!
   (=>
    (has_type closure%$ (TYPE%tuple%1. (REF Self%&.) Self%&))
    (=>
     (let
      ((self$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      true
     )
     (closure_req (FNDEF%core!clone.Clone.clone. Self%&. Self%&) (DST (REF Self%&.)) (TYPE%tuple%1.
       (REF Self%&.) Self%&
      ) (F fndef_singleton) closure%$
   )))
   :pattern ((closure_req (FNDEF%core!clone.Clone.clone. Self%&. Self%&) (DST (REF Self%&.))
     (TYPE%tuple%1. (REF Self%&.) Self%&) (F fndef_singleton) closure%$
   ))
   :qid user_core__clone__Clone__clone_34
   :skolemid skolem_user_core__clone__Clone__clone_34
)))

;; Function-Axioms vstd::std_specs::core::IndexSetTrustedSpec::spec_index_set_requires
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Idx&. Dcr) (Idx& Type) (self! Poly) (index! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type index! Idx&)
    )
    (has_type (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? Self%&.
      Self%& Idx&. Idx& self! index!
     ) BOOL
   ))
   :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? Self%&.
     Self%& Idx&. Idx& self! index!
   ))
   :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::core::IndexSetTrustedSpec::spec_index_set_ensures
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Idx&. Dcr) (Idx& Type) (self! Poly) (new_container!
    Poly
   ) (index! Poly) (val! Poly)
  ) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type new_container! Self%&)
     (has_type index! Idx&)
     (has_type val! (proj%core!ops.index.Index./Output Self%&. Self%& Idx&. Idx&))
    )
    (has_type (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? Self%&.
      Self%& Idx&. Idx& self! new_container! index! val!
     ) BOOL
   ))
   :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? Self%&.
     Self%& Idx&. Idx& self! new_container! index! val!
   ))
   :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_pre_post_definition
)))

;; Function-Specs core::clone::impls::impl&%6::clone
(declare-fun ens%core!clone.impls.impl&%6.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%6.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT 8) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%6.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__6.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__6.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (UINT 8)))
     (has_type res$ (UINT 8))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 8)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (UINT 8)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 8)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (UINT 8)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%6__clone_35
   :skolemid skolem_user_core__clone__impls__impl&%6__clone_35
)))

;; Function-Specs core::clone::impls::impl&%12::clone
(declare-fun ens%core!clone.impls.impl&%12.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%12.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (SINT 8) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%12.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__12.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__12.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (SINT 8)))
     (has_type res$ (SINT 8))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (SINT 8)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (SINT 8)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (SINT 8)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (SINT 8)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%12__clone_36
   :skolemid skolem_user_core__clone__impls__impl&%12__clone_36
)))

;; Function-Specs core::clone::impls::impl&%7::clone
(declare-fun ens%core!clone.impls.impl&%7.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%7.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT 16) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%7.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__7.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__7.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (UINT 16)))
     (has_type res$ (UINT 16))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 16)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (UINT 16)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 16)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (UINT 16)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%7__clone_37
   :skolemid skolem_user_core__clone__impls__impl&%7__clone_37
)))

;; Function-Specs core::clone::impls::impl&%13::clone
(declare-fun ens%core!clone.impls.impl&%13.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%13.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (SINT 16) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%13.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__13.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__13.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (SINT 16)))
     (has_type res$ (SINT 16))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (SINT 16)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (SINT 16)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (SINT 16)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (SINT 16)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%13__clone_38
   :skolemid skolem_user_core__clone__impls__impl&%13__clone_38
)))

;; Function-Specs core::clone::impls::impl&%8::clone
(declare-fun ens%core!clone.impls.impl&%8.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%8.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT 32) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%8.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__8.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__8.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (UINT 32)))
     (has_type res$ (UINT 32))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 32)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (UINT 32)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 32)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (UINT 32)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%8__clone_39
   :skolemid skolem_user_core__clone__impls__impl&%8__clone_39
)))

;; Function-Specs core::clone::impls::impl&%14::clone
(declare-fun ens%core!clone.impls.impl&%14.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%14.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (SINT 32) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%14.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__14.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__14.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (SINT 32)))
     (has_type res$ (SINT 32))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (SINT 32)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (SINT 32)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (SINT 32)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (SINT 32)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%14__clone_40
   :skolemid skolem_user_core__clone__impls__impl&%14__clone_40
)))

;; Function-Specs core::clone::impls::impl&%9::clone
(declare-fun ens%core!clone.impls.impl&%9.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%9.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT 64) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%9.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__9.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__9.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (UINT 64)))
     (has_type res$ (UINT 64))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 64)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (UINT 64)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 64)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (UINT 64)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%9__clone_41
   :skolemid skolem_user_core__clone__impls__impl&%9__clone_41
)))

;; Function-Specs core::clone::impls::impl&%5::clone
(declare-fun ens%core!clone.impls.impl&%5.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%5.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ USIZE x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%5.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__5.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__5.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) USIZE))
     (has_type res$ USIZE)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ USIZE) (DST (REF $)) (TYPE%tuple%1. (
        REF $
       ) USIZE
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ USIZE) (DST (REF $)) (TYPE%tuple%1.
      (REF $) USIZE
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%5__clone_42
   :skolemid skolem_user_core__clone__impls__impl&%5__clone_42
)))

;; Function-Axioms vstd::arithmetic::power2::pow2
(assert
 (forall ((e! Poly)) (!
   (=>
    (has_type e! NAT)
    (<= 0 (vstd!arithmetic.power2.pow2.? e!))
   )
   :pattern ((vstd!arithmetic.power2.pow2.? e!))
   :qid internal_vstd!arithmetic.power2.pow2.?_pre_post_definition
   :skolemid skolem_internal_vstd!arithmetic.power2.pow2.?_pre_post_definition
)))

;; Function-Specs core::clone::impls::impl&%21::clone
(declare-fun ens%core!clone.impls.impl&%21.clone. (Poly Poly) Bool)
(assert
 (forall ((b! Poly) (%return! Poly)) (!
   (= (ens%core!clone.impls.impl&%21.clone. b! %return!) (and
     (ens%core!clone.Clone.clone. $ BOOL b! %return!)
     (= %return! b!)
   ))
   :pattern ((ens%core!clone.impls.impl&%21.clone. b! %return!))
   :qid internal_ens__core!clone.impls.impl&__21.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__21.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (%return$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) BOOL))
     (has_type %return$ BOOL)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ BOOL) (DST (REF $)) (TYPE%tuple%1. (REF
        $
       ) BOOL
      ) (F fndef_singleton) closure%$ %return$
     )
     (let
      ((b$ (%B (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%B %return$) b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ BOOL) (DST (REF $)) (TYPE%tuple%1.
      (REF $) BOOL
     ) (F fndef_singleton) closure%$ %return$
   ))
   :qid user_core__clone__impls__impl&%21__clone_43
   :skolemid skolem_user_core__clone__impls__impl&%21__clone_43
)))

;; Function-Specs core::clone::impls::impl&%22::clone
(declare-fun ens%core!clone.impls.impl&%22.clone. (Poly Poly) Bool)
(assert
 (forall ((c! Poly) (%return! Poly)) (!
   (= (ens%core!clone.impls.impl&%22.clone. c! %return!) (and
     (ens%core!clone.Clone.clone. $ CHAR c! %return!)
     (= %return! c!)
   ))
   :pattern ((ens%core!clone.impls.impl&%22.clone. c! %return!))
   :qid internal_ens__core!clone.impls.impl&__22.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__22.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (%return$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) CHAR))
     (has_type %return$ CHAR)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ CHAR) (DST (REF $)) (TYPE%tuple%1. (REF
        $
       ) CHAR
      ) (F fndef_singleton) closure%$ %return$
     )
     (let
      ((c$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I %return$) c$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ CHAR) (DST (REF $)) (TYPE%tuple%1.
      (REF $) CHAR
     ) (F fndef_singleton) closure%$ %return$
   ))
   :qid user_core__clone__impls__impl&%22__clone_44
   :skolemid skolem_user_core__clone__impls__impl&%22__clone_44
)))

;; Function-Specs core::clone::impls::impl&%3::clone
(declare-fun ens%core!clone.impls.impl&%3.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (b! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%3.clone. T&. T& b! res!) (and
     (ens%core!clone.Clone.clone. (REF T&.) T& b! res!)
     (= res! b!)
   ))
   :pattern ((ens%core!clone.impls.impl&%3.clone. T&. T& b! res!))
   :qid internal_ens__core!clone.impls.impl&__3.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__3.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (REF T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (REF T&.) T&) (DST (REF (REF T&.))) (TYPE%tuple%1.
       (REF (REF T&.)) T&
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (= res$ b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (REF T&.) T&) (DST (REF (REF T&.)))
     (TYPE%tuple%1. (REF (REF T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%3__clone_45
   :skolemid skolem_user_core__clone__impls__impl&%3__clone_45
)))

;; Function-Axioms vstd::pervasive::strictly_cloned
(assert
 (fuel_bool_default fuel%vstd!pervasive.strictly_cloned.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!pervasive.strictly_cloned.)
  (forall ((T&. Dcr) (T& Type) (a! Poly) (b! Poly)) (!
    (= (vstd!pervasive.strictly_cloned.? T&. T& a! b!) (closure_ens (FNDEF%core!clone.Clone.clone.
       T&. T&
      ) (DST (REF T&.)) (TYPE%tuple%1. (REF T&.) T&) (F fndef_singleton) (Poly%tuple%1.
       (tuple%1./tuple%1 a!)
      ) b!
    ))
    :pattern ((vstd!pervasive.strictly_cloned.? T&. T& a! b!))
    :qid internal_vstd!pervasive.strictly_cloned.?_definition
    :skolemid skolem_internal_vstd!pervasive.strictly_cloned.?_definition
))))

;; Function-Axioms vstd::pervasive::cloned
(assert
 (fuel_bool_default fuel%vstd!pervasive.cloned.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!pervasive.cloned.)
  (forall ((T&. Dcr) (T& Type) (a! Poly) (b! Poly)) (!
    (= (vstd!pervasive.cloned.? T&. T& a! b!) (or
      (vstd!pervasive.strictly_cloned.? T&. T& a! b!)
      (= a! b!)
    ))
    :pattern ((vstd!pervasive.cloned.? T&. T& a! b!))
    :qid internal_vstd!pervasive.cloned.?_definition
    :skolemid skolem_internal_vstd!pervasive.cloned.?_definition
))))

;; Function-Specs core::array::impl&%20::clone
(declare-fun ens%core!array.impl&%20.clone. (Dcr Type Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly) (res! Poly)) (!
   (= (ens%core!array.impl&%20.clone. T&. T& N&. N& a! res!) (and
     (ens%core!clone.Clone.clone. $ (ARRAY T&. T& N&. N&) a! res!)
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (const_int N&))
         ))
         (vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
            $ (ARRAY T&. T& N&. N&) a!
           ) i$
          ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res!)
           i$
       ))))
       :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
          a!
         ) i$
       ))
       :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
          res!
         ) i$
       ))
       :pattern ((vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
           $ (ARRAY T&. T& N&. N&) a!
          ) i$
         ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res!)
          i$
       )))
       :qid user_core__array__impl&%20__clone_46
       :skolemid skolem_user_core__array__impl&%20__clone_46
     ))
     (=>
      (ext_eq false (TYPE%vstd!seq.Seq. T&. T&) (vstd!view.View.view.? $ (ARRAY T&. T& N&.
         N&
        ) a!
       ) (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res!)
      )
      (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a!) (vstd!view.View.view.? $ (ARRAY
         T&. T& N&. N&
        ) res!
   )))))
   :pattern ((ens%core!array.impl&%20.clone. T&. T& N&. N& a! res!))
   :qid internal_ens__core!array.impl&__20.clone._definition
   :skolemid skolem_internal_ens__core!array.impl&__20.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (ARRAY T&. T& N&. N&)))
     (has_type res$ (ARRAY T&. T& N&. N&))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (ARRAY T&. T& N&. N&)) (DST (REF $))
      (TYPE%tuple%1. (REF $) (ARRAY T&. T& N&. N&)) (F fndef_singleton) closure%$ res$
     )
     (let
      ((a$ (%Poly%array%. (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (and
       (forall ((i$ Poly)) (!
         (=>
          (has_type i$ INT)
          (=>
           (let
            ((tmp%%$ (%I i$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ (const_int N&))
           ))
           (vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
              $ (ARRAY T&. T& N&. N&) (Poly%array%. a$)
             ) i$
            ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res$)
             i$
         ))))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            (Poly%array%. a$)
           ) i$
         ))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            res$
           ) i$
         ))
         :pattern ((vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
             $ (ARRAY T&. T& N&. N&) (Poly%array%. a$)
            ) i$
           ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res$)
            i$
         )))
         :qid user_core__array__impl&%20__clone_47
         :skolemid skolem_user_core__array__impl&%20__clone_47
       ))
       (=>
        (ext_eq false (TYPE%vstd!seq.Seq. T&. T&) (vstd!view.View.view.? $ (ARRAY T&. T& N&.
           N&
          ) (Poly%array%. a$)
         ) (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res$)
        )
        (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) (Poly%array%. a$)) (vstd!view.View.view.?
          $ (ARRAY T&. T& N&. N&) res$
   )))))))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (ARRAY T&. T& N&. N&)) (DST
      (REF $)
     ) (TYPE%tuple%1. (REF $) (ARRAY T&. T& N&. N&)) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__array__impl&%20__clone_48
   :skolemid skolem_user_core__array__impl&%20__clone_48
)))

;; Function-Specs verus_builtin::impl&%5::clone
(declare-fun ens%verus_builtin!impl&%5.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (b! Poly) (res! Poly)) (!
   (= (ens%verus_builtin!impl&%5.clone. T&. T& b! res!) (and
     (ens%core!clone.Clone.clone. (TRACKED T&.) T& b! res!)
     (= res! b!)
   ))
   :pattern ((ens%verus_builtin!impl&%5.clone. T&. T& b! res!))
   :qid internal_ens__verus_builtin!impl&__5.clone._definition
   :skolemid skolem_internal_ens__verus_builtin!impl&__5.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (TRACKED T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (TRACKED T&.) T&) (DST (REF (TRACKED T&.)))
      (TYPE%tuple%1. (REF (TRACKED T&.)) T&) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (= res$ b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (TRACKED T&.) T&) (DST (REF (TRACKED
        T&.
      ))
     ) (TYPE%tuple%1. (REF (TRACKED T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_verus_builtin__impl&%5__clone_49
   :skolemid skolem_user_verus_builtin__impl&%5__clone_49
)))

;; Function-Specs verus_builtin::impl&%3::clone
(declare-fun ens%verus_builtin!impl&%3.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (b! Poly) (res! Poly)) (!
   (= (ens%verus_builtin!impl&%3.clone. T&. T& b! res!) (and
     (ens%core!clone.Clone.clone. (GHOST T&.) T& b! res!)
     (= res! b!)
   ))
   :pattern ((ens%verus_builtin!impl&%3.clone. T&. T& b! res!))
   :qid internal_ens__verus_builtin!impl&__3.clone._definition
   :skolemid skolem_internal_ens__verus_builtin!impl&__3.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (GHOST T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (GHOST T&.) T&) (DST (REF (GHOST T&.)))
      (TYPE%tuple%1. (REF (GHOST T&.)) T&) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (= res$ b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (GHOST T&.) T&) (DST (REF (GHOST
        T&.
      ))
     ) (TYPE%tuple%1. (REF (GHOST T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_verus_builtin__impl&%3__clone_50
   :skolemid skolem_user_verus_builtin__impl&%3__clone_50
)))

;; Function-Axioms vstd::std_specs::convert::FromSpec::obeys_from_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (has_type (vstd!std_specs.convert.FromSpec.obeys_from_spec.? Self%&. Self%& T&. T&)
    BOOL
   )
   :pattern ((vstd!std_specs.convert.FromSpec.obeys_from_spec.? Self%&. Self%& T&. T&))
   :qid internal_vstd!std_specs.convert.FromSpec.obeys_from_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.obeys_from_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::convert::FromSpec::from_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (v! Poly)) (!
   (=>
    (has_type v! T&)
    (has_type (vstd!std_specs.convert.FromSpec.from_spec.? Self%&. Self%& T&. T& v!) Self%&)
   )
   :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? Self%&. Self%& T&. T& v!))
   :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_pre_post_definition
)))

;; Function-Specs core::convert::From::from
(declare-fun ens%core!convert.From.from. (Dcr Type Dcr Type Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (v! Poly) (ret! Poly)) (!
   (= (ens%core!convert.From.from. Self%&. Self%& T&. T& v! ret!) (and
     (has_type ret! Self%&)
     (=>
      (%B (vstd!std_specs.convert.FromSpec.obeys_from_spec.? Self%&. Self%& T&. T&))
      (= ret! (vstd!std_specs.convert.FromSpec.from_spec.? Self%&. Self%& T&. T& v!))
   )))
   :pattern ((ens%core!convert.From.from. Self%&. Self%& T&. T& v! ret!))
   :qid internal_ens__core!convert.From.from._definition
   :skolemid skolem_internal_ens__core!convert.From.from._definition
)))
(assert
 (forall ((closure%$ Poly) (Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (has_type closure%$ (TYPE%tuple%1. T&. T&))
    (=>
     (let
      ((v$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      true
     )
     (closure_req (FNDEF%core!convert.From.from. Self%&. Self%& T&. T&) (DST T&.) (TYPE%tuple%1.
       T&. T&
      ) (F fndef_singleton) closure%$
   )))
   :pattern ((closure_req (FNDEF%core!convert.From.from. Self%&. Self%& T&. T&) (DST T&.)
     (TYPE%tuple%1. T&. T&) (F fndef_singleton) closure%$
   ))
   :qid user_core__convert__From__from_51
   :skolemid skolem_user_core__convert__From__from_51
)))
(assert
 (forall ((closure%$ Poly) (ret$ Poly) (Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type))
  (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. T&. T&))
     (has_type ret$ Self%&)
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. Self%&. Self%& T&. T&) (DST T&.) (TYPE%tuple%1.
       T&. T&
      ) (F fndef_singleton) closure%$ ret$
     )
     (let
      ((v$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (=>
       (%B (vstd!std_specs.convert.FromSpec.obeys_from_spec.? Self%&. Self%& T&. T&))
       (= ret$ (vstd!std_specs.convert.FromSpec.from_spec.? Self%&. Self%& T&. T& v$))
   ))))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. Self%&. Self%& T&. T&) (DST T&.)
     (TYPE%tuple%1. T&. T&) (F fndef_singleton) closure%$ ret$
   ))
   :qid user_core__convert__From__from_52
   :skolemid skolem_user_core__convert__From__from_52
)))

;; Function-Specs core::iter::traits::iterator::Iterator::next
(declare-fun ens%core!iter.traits.iterator.Iterator.next. (Dcr Type Poly Poly Poly)
 Bool
)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (pre%self! Poly) (self! Poly) (%return! Poly))
  (!
   (= (ens%core!iter.traits.iterator.Iterator.next. Self%&. Self%& pre%self! self! %return!)
    (and
     (has_type %return! (TYPE%core!option.Option. (proj%%core!iter.traits.iterator.Iterator./Item
        Self%&. Self%&
       ) (proj%core!iter.traits.iterator.Iterator./Item Self%&. Self%&)
     ))
     (has_type self! Self%&)
   ))
   :pattern ((ens%core!iter.traits.iterator.Iterator.next. Self%&. Self%& pre%self! self!
     %return!
   ))
   :qid internal_ens__core!iter.traits.iterator.Iterator.next._definition
   :skolemid skolem_internal_ens__core!iter.traits.iterator.Iterator.next._definition
)))

;; Function-Specs core::iter::traits::collect::impl&%0::into_iter
(declare-fun ens%core!iter.traits.collect.impl&%0.into_iter. (Dcr Type Poly Poly)
 Bool
)
(assert
 (forall ((I&. Dcr) (I& Type) (i! Poly) (r! Poly)) (!
   (= (ens%core!iter.traits.collect.impl&%0.into_iter. I&. I& i! r!) (and
     (has_type r! I&)
     (= r! i!)
   ))
   :pattern ((ens%core!iter.traits.collect.impl&%0.into_iter. I&. I& i! r!))
   :qid internal_ens__core!iter.traits.collect.impl&__0.into_iter._definition
   :skolemid skolem_internal_ens__core!iter.traits.collect.impl&__0.into_iter._definition
)))

;; Function-Specs vstd::std_specs::core::index_set
(declare-fun req%vstd!std_specs.core.index_set. (Dcr Type Dcr Type Dcr Type Poly Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%5 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (Idx&. Dcr) (Idx& Type) (E&. Dcr) (E& Type) (pre%container!
    Poly
   ) (index! Poly) (val! Poly)
  ) (!
   (= (req%vstd!std_specs.core.index_set. T&. T& Idx&. Idx& E&. E& pre%container! index!
     val!
    ) (=>
     %%global_location_label%%5
     (%B (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? T&. T& Idx&.
       Idx& pre%container! index!
   ))))
   :pattern ((req%vstd!std_specs.core.index_set. T&. T& Idx&. Idx& E&. E& pre%container!
     index! val!
   ))
   :qid internal_req__vstd!std_specs.core.index_set._definition
   :skolemid skolem_internal_req__vstd!std_specs.core.index_set._definition
)))
(declare-fun ens%vstd!std_specs.core.index_set. (Dcr Type Dcr Type Dcr Type Poly Poly
  Poly Poly
 ) Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (Idx&. Dcr) (Idx& Type) (E&. Dcr) (E& Type) (pre%container!
    Poly
   ) (container! Poly) (index! Poly) (val! Poly)
  ) (!
   (= (ens%vstd!std_specs.core.index_set. T&. T& Idx&. Idx& E&. E& pre%container! container!
     index! val!
    ) (and
     (has_type container! T&)
     (%B (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? T&. T& Idx&.
       Idx& pre%container! container! index! val!
   ))))
   :pattern ((ens%vstd!std_specs.core.index_set. T&. T& Idx&. Idx& E&. E& pre%container!
     container! index! val!
   ))
   :qid internal_ens__vstd!std_specs.core.index_set._definition
   :skolemid skolem_internal_ens__vstd!std_specs.core.index_set._definition
)))

;; Function-Specs core::default::Default::default
(declare-fun ens%core!default.Default.default. (Dcr Type Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (%return! Poly)) (!
   (= (ens%core!default.Default.default. Self%&. Self%& %return!) (has_type %return! Self%&))
   :pattern ((ens%core!default.Default.default. Self%&. Self%& %return!))
   :qid internal_ens__core!default.Default.default._definition
   :skolemid skolem_internal_ens__core!default.Default.default._definition
)))
(assert
 (forall ((closure%$ Poly) (Self%&. Dcr) (Self%& Type)) (!
   (=>
    (has_type closure%$ TYPE%tuple%0.)
    (closure_req (FNDEF%core!default.Default.default. Self%&. Self%&) $ TYPE%tuple%0.
     (F fndef_singleton) closure%$
   ))
   :pattern ((closure_req (FNDEF%core!default.Default.default. Self%&. Self%&) $ TYPE%tuple%0.
     (F fndef_singleton) closure%$
   ))
   :qid user_core__default__Default__default_53
   :skolemid skolem_user_core__default__Default__default_53
)))

;; Function-Specs core::default::impl&%1::default
(declare-fun ens%core!default.impl&%1.default. (Poly) Bool)
(assert
 (forall ((r! Poly)) (!
   (= (ens%core!default.impl&%1.default. r!) (and
     (ens%core!default.Default.default. $ BOOL r!)
     (= (%B r!) false)
   ))
   :pattern ((ens%core!default.impl&%1.default. r!))
   :qid internal_ens__core!default.impl&__1.default._definition
   :skolemid skolem_internal_ens__core!default.impl&__1.default._definition
)))
(assert
 (forall ((closure%$ Poly) (r$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type r$ BOOL)
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ BOOL) $ TYPE%tuple%0. (F fndef_singleton)
      closure%$ r$
     )
     (= (%B r$) false)
   ))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ BOOL) $ TYPE%tuple%0.
     (F fndef_singleton) closure%$ r$
   ))
   :qid user_core__default__impl&%1__default_54
   :skolemid skolem_user_core__default__impl&%1__default_54
)))

;; Function-Specs core::default::impl&%2::default
(declare-fun ens%core!default.impl&%2.default. (Poly) Bool)
(assert
 (forall ((r! Poly)) (!
   (= (ens%core!default.impl&%2.default. r!) (and
     (ens%core!default.Default.default. $ CHAR r!)
     (= (%I r!) 0)
   ))
   :pattern ((ens%core!default.impl&%2.default. r!))
   :qid internal_ens__core!default.impl&__2.default._definition
   :skolemid skolem_internal_ens__core!default.impl&__2.default._definition
)))
(assert
 (forall ((closure%$ Poly) (r$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type r$ CHAR)
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ CHAR) $ TYPE%tuple%0. (F fndef_singleton)
      closure%$ r$
     )
     (= (%I r$) 0)
   ))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ CHAR) $ TYPE%tuple%0.
     (F fndef_singleton) closure%$ r$
   ))
   :qid user_core__default__impl&%2__default_55
   :skolemid skolem_user_core__default__impl&%2__default_55
)))

;; Function-Specs core::default::impl&%11::default
(declare-fun ens%core!default.impl&%11.default. (Poly) Bool)
(assert
 (forall ((r! Poly)) (!
   (= (ens%core!default.impl&%11.default. r!) (and
     (ens%core!default.Default.default. $ (SINT 8) r!)
     (= (%I r!) 0)
   ))
   :pattern ((ens%core!default.impl&%11.default. r!))
   :qid internal_ens__core!default.impl&__11.default._definition
   :skolemid skolem_internal_ens__core!default.impl&__11.default._definition
)))
(assert
 (forall ((closure%$ Poly) (r$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type r$ (SINT 8))
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ (SINT 8)) $ TYPE%tuple%0. (F fndef_singleton)
      closure%$ r$
     )
     (= (%I r$) 0)
   ))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ (SINT 8)) $ TYPE%tuple%0.
     (F fndef_singleton) closure%$ r$
   ))
   :qid user_core__default__impl&%11__default_56
   :skolemid skolem_user_core__default__impl&%11__default_56
)))

;; Function-Specs core::default::impl&%12::default
(declare-fun ens%core!default.impl&%12.default. (Poly) Bool)
(assert
 (forall ((r! Poly)) (!
   (= (ens%core!default.impl&%12.default. r!) (and
     (ens%core!default.Default.default. $ (SINT 16) r!)
     (= (%I r!) 0)
   ))
   :pattern ((ens%core!default.impl&%12.default. r!))
   :qid internal_ens__core!default.impl&__12.default._definition
   :skolemid skolem_internal_ens__core!default.impl&__12.default._definition
)))
(assert
 (forall ((closure%$ Poly) (r$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type r$ (SINT 16))
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ (SINT 16)) $ TYPE%tuple%0. (F fndef_singleton)
      closure%$ r$
     )
     (= (%I r$) 0)
   ))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ (SINT 16)) $ TYPE%tuple%0.
     (F fndef_singleton) closure%$ r$
   ))
   :qid user_core__default__impl&%12__default_57
   :skolemid skolem_user_core__default__impl&%12__default_57
)))

;; Function-Specs core::default::impl&%13::default
(declare-fun ens%core!default.impl&%13.default. (Poly) Bool)
(assert
 (forall ((r! Poly)) (!
   (= (ens%core!default.impl&%13.default. r!) (and
     (ens%core!default.Default.default. $ (SINT 32) r!)
     (= (%I r!) 0)
   ))
   :pattern ((ens%core!default.impl&%13.default. r!))
   :qid internal_ens__core!default.impl&__13.default._definition
   :skolemid skolem_internal_ens__core!default.impl&__13.default._definition
)))
(assert
 (forall ((closure%$ Poly) (r$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type r$ (SINT 32))
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ (SINT 32)) $ TYPE%tuple%0. (F fndef_singleton)
      closure%$ r$
     )
     (= (%I r$) 0)
   ))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ (SINT 32)) $ TYPE%tuple%0.
     (F fndef_singleton) closure%$ r$
   ))
   :qid user_core__default__impl&%13__default_58
   :skolemid skolem_user_core__default__impl&%13__default_58
)))

;; Function-Specs core::default::impl&%5::default
(declare-fun ens%core!default.impl&%5.default. (Poly) Bool)
(assert
 (forall ((r! Poly)) (!
   (= (ens%core!default.impl&%5.default. r!) (and
     (ens%core!default.Default.default. $ (UINT 8) r!)
     (= (%I r!) 0)
   ))
   :pattern ((ens%core!default.impl&%5.default. r!))
   :qid internal_ens__core!default.impl&__5.default._definition
   :skolemid skolem_internal_ens__core!default.impl&__5.default._definition
)))
(assert
 (forall ((closure%$ Poly) (r$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type r$ (UINT 8))
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ (UINT 8)) $ TYPE%tuple%0. (F fndef_singleton)
      closure%$ r$
     )
     (= (%I r$) 0)
   ))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ (UINT 8)) $ TYPE%tuple%0.
     (F fndef_singleton) closure%$ r$
   ))
   :qid user_core__default__impl&%5__default_59
   :skolemid skolem_user_core__default__impl&%5__default_59
)))

;; Function-Specs core::default::impl&%6::default
(declare-fun ens%core!default.impl&%6.default. (Poly) Bool)
(assert
 (forall ((r! Poly)) (!
   (= (ens%core!default.impl&%6.default. r!) (and
     (ens%core!default.Default.default. $ (UINT 16) r!)
     (= (%I r!) 0)
   ))
   :pattern ((ens%core!default.impl&%6.default. r!))
   :qid internal_ens__core!default.impl&__6.default._definition
   :skolemid skolem_internal_ens__core!default.impl&__6.default._definition
)))
(assert
 (forall ((closure%$ Poly) (r$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type r$ (UINT 16))
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ (UINT 16)) $ TYPE%tuple%0. (F fndef_singleton)
      closure%$ r$
     )
     (= (%I r$) 0)
   ))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ (UINT 16)) $ TYPE%tuple%0.
     (F fndef_singleton) closure%$ r$
   ))
   :qid user_core__default__impl&%6__default_60
   :skolemid skolem_user_core__default__impl&%6__default_60
)))

;; Function-Specs core::default::impl&%7::default
(declare-fun ens%core!default.impl&%7.default. (Poly) Bool)
(assert
 (forall ((r! Poly)) (!
   (= (ens%core!default.impl&%7.default. r!) (and
     (ens%core!default.Default.default. $ (UINT 32) r!)
     (= (%I r!) 0)
   ))
   :pattern ((ens%core!default.impl&%7.default. r!))
   :qid internal_ens__core!default.impl&__7.default._definition
   :skolemid skolem_internal_ens__core!default.impl&__7.default._definition
)))
(assert
 (forall ((closure%$ Poly) (r$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type r$ (UINT 32))
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ (UINT 32)) $ TYPE%tuple%0. (F fndef_singleton)
      closure%$ r$
     )
     (= (%I r$) 0)
   ))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ (UINT 32)) $ TYPE%tuple%0.
     (F fndef_singleton) closure%$ r$
   ))
   :qid user_core__default__impl&%7__default_61
   :skolemid skolem_user_core__default__impl&%7__default_61
)))

;; Function-Specs core::default::impl&%8::default
(declare-fun ens%core!default.impl&%8.default. (Poly) Bool)
(assert
 (forall ((r! Poly)) (!
   (= (ens%core!default.impl&%8.default. r!) (and
     (ens%core!default.Default.default. $ (UINT 64) r!)
     (= (%I r!) 0)
   ))
   :pattern ((ens%core!default.impl&%8.default. r!))
   :qid internal_ens__core!default.impl&__8.default._definition
   :skolemid skolem_internal_ens__core!default.impl&__8.default._definition
)))
(assert
 (forall ((closure%$ Poly) (r$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type r$ (UINT 64))
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ (UINT 64)) $ TYPE%tuple%0. (F fndef_singleton)
      closure%$ r$
     )
     (= (%I r$) 0)
   ))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ (UINT 64)) $ TYPE%tuple%0.
     (F fndef_singleton) closure%$ r$
   ))
   :qid user_core__default__impl&%8__default_62
   :skolemid skolem_user_core__default__impl&%8__default_62
)))

;; Function-Specs core::default::impl&%0::default
(declare-fun ens%core!default.impl&%0.default. (Poly) Bool)
(assert
 (forall ((r! Poly)) (!
   (= (ens%core!default.impl&%0.default. r!) (and
     (ens%core!default.Default.default. $ TYPE%tuple%0. r!)
     (= tuple%0./tuple%0 tuple%0./tuple%0)
   ))
   :pattern ((ens%core!default.impl&%0.default. r!))
   :qid internal_ens__core!default.impl&__0.default._definition
   :skolemid skolem_internal_ens__core!default.impl&__0.default._definition
)))
(assert
 (forall ((closure%$ Poly) (r$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type r$ TYPE%tuple%0.)
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ TYPE%tuple%0.) $ TYPE%tuple%0.
      (F fndef_singleton) closure%$ r$
     )
     (= tuple%0./tuple%0 tuple%0./tuple%0)
   ))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ TYPE%tuple%0.) $ TYPE%tuple%0.
     (F fndef_singleton) closure%$ r$
   ))
   :qid user_core__default__impl&%0__default_63
   :skolemid skolem_user_core__default__impl&%0__default_63
)))

;; Function-Specs core::default::impl&%4::default
(declare-fun ens%core!default.impl&%4.default. (Poly) Bool)
(assert
 (forall ((r! Poly)) (!
   (= (ens%core!default.impl&%4.default. r!) (and
     (ens%core!default.Default.default. $ USIZE r!)
     (= (%I r!) 0)
   ))
   :pattern ((ens%core!default.impl&%4.default. r!))
   :qid internal_ens__core!default.impl&__4.default._definition
   :skolemid skolem_internal_ens__core!default.impl&__4.default._definition
)))
(assert
 (forall ((closure%$ Poly) (r$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type r$ USIZE)
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ USIZE) $ TYPE%tuple%0. (F fndef_singleton)
      closure%$ r$
     )
     (= (%I r$) 0)
   ))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ USIZE) $ TYPE%tuple%0.
     (F fndef_singleton) closure%$ r$
   ))
   :qid user_core__default__impl&%4__default_64
   :skolemid skolem_user_core__default__impl&%4__default_64
)))

;; Function-Specs core::option::impl&%7::default
(declare-fun ens%core!option.impl&%7.default. (Dcr Type Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (r! Poly)) (!
   (= (ens%core!option.impl&%7.default. T&. T& r!) (and
     (ens%core!default.Default.default. $ (TYPE%core!option.Option. T&. T&) r!)
     (= (%Poly%core!option.Option. r!) core!option.Option./None)
   ))
   :pattern ((ens%core!option.impl&%7.default. T&. T& r!))
   :qid internal_ens__core!option.impl&__7.default._definition
   :skolemid skolem_internal_ens__core!option.impl&__7.default._definition
)))
(assert
 (forall ((closure%$ Poly) (r$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type r$ (TYPE%core!option.Option. T&. T&))
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ (TYPE%core!option.Option. T&. T&))
      $ TYPE%tuple%0. (F fndef_singleton) closure%$ r$
     )
     (= (%Poly%core!option.Option. r$) core!option.Option./None)
   ))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ (TYPE%core!option.Option.
       T&. T&
      )
     ) $ TYPE%tuple%0. (F fndef_singleton) closure%$ r$
   ))
   :qid user_core__option__impl&%7__default_65
   :skolemid skolem_user_core__option__impl&%7__default_65
)))

;; Function-Specs core::str::impl&%2::default
(declare-fun ens%core!str.impl&%2.default. (Poly) Bool)
(assert
 (forall ((r! Poly)) (!
   (= (ens%core!str.impl&%2.default. r!) (and
     (ens%core!default.Default.default. (REF $slice) STRSLICE r!)
     (= (%Poly%strslice%. r!) (str%new_strlit 3291835376408573590478209986637364656599265025014012802863049622424083630783948306431999498413285667939592978357630573418285899181951386474024455144309711))
   ))
   :pattern ((ens%core!str.impl&%2.default. r!))
   :qid internal_ens__core!str.impl&__2.default._definition
   :skolemid skolem_internal_ens__core!str.impl&__2.default._definition
)))
(assert
 (forall ((closure%$ Poly) (r$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type r$ STRSLICE)
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. (REF $slice) STRSLICE) $ TYPE%tuple%0.
      (F fndef_singleton) closure%$ r$
     )
     (= (%Poly%strslice%. r$) (str%new_strlit 3291835376408573590478209986637364656599265025014012802863049622424083630783948306431999498413285667939592978357630573418285899181951386474024455144309711))
   ))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. (REF $slice) STRSLICE)
     $ TYPE%tuple%0. (F fndef_singleton) closure%$ r$
   ))
   :qid user_core__str__impl&%2__default_66
   :skolemid skolem_user_core__str__impl&%2__default_66
)))

;; Function-Specs core::tuple::impl&%16::default
(declare-fun ens%core!tuple.impl&%16.default. (Dcr Type Dcr Type Poly) Bool)
(assert
 (forall ((U&. Dcr) (U& Type) (T&. Dcr) (T& Type) (r! Poly)) (!
   (= (ens%core!tuple.impl&%16.default. U&. U& T&. T& r!) (and
     (ens%core!default.Default.default. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&) r!)
     (closure_ens (FNDEF%core!default.Default.default. U&. U&) $ TYPE%tuple%0. (F fndef_singleton)
      (Poly%tuple%0. tuple%0./tuple%0) (tuple%2./tuple%2/0 (%Poly%tuple%2. r!))
     )
     (closure_ens (FNDEF%core!default.Default.default. T&. T&) $ TYPE%tuple%0. (F fndef_singleton)
      (Poly%tuple%0. tuple%0./tuple%0) (tuple%2./tuple%2/1 (%Poly%tuple%2. r!))
   )))
   :pattern ((ens%core!tuple.impl&%16.default. U&. U& T&. T& r!))
   :qid internal_ens__core!tuple.impl&__16.default._definition
   :skolemid skolem_internal_ens__core!tuple.impl&__16.default._definition
)))
(assert
 (forall ((closure%$ Poly) (r$ Poly) (U&. Dcr) (U& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type r$ (TYPE%tuple%2. U&. U& T&. T&))
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. (DST T&.) (TYPE%tuple%2. U&. U& T&.
        T&
       )
      ) $ TYPE%tuple%0. (F fndef_singleton) closure%$ r$
     )
     (and
      (closure_ens (FNDEF%core!default.Default.default. U&. U&) $ TYPE%tuple%0. (F fndef_singleton)
       (Poly%tuple%0. tuple%0./tuple%0) (tuple%2./tuple%2/0 (%Poly%tuple%2. r$))
      )
      (closure_ens (FNDEF%core!default.Default.default. T&. T&) $ TYPE%tuple%0. (F fndef_singleton)
       (Poly%tuple%0. tuple%0./tuple%0) (tuple%2./tuple%2/1 (%Poly%tuple%2. r$))
   ))))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. (DST T&.) (TYPE%tuple%2.
       U&. U& T&. T&
      )
     ) $ TYPE%tuple%0. (F fndef_singleton) closure%$ r$
   ))
   :qid user_core__tuple__impl&%16__default_67
   :skolemid skolem_user_core__tuple__impl&%16__default_67
)))

;; Function-Axioms vstd::std_specs::ops::AddSpec::add_req
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.AddSpec.add_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     BOOL
   ))
   :pattern ((vstd!std_specs.ops.AddSpec.add_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::AddSpec::obeys_add_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (has_type (vstd!std_specs.ops.AddSpec.obeys_add_spec.? Self%&. Self%& Rhs&. Rhs&)
    BOOL
   )
   :pattern ((vstd!std_specs.ops.AddSpec.obeys_add_spec.? Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd!std_specs.ops.AddSpec.obeys_add_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.obeys_add_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::AddSpec::add_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.AddSpec.add_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     (proj%core!ops.arith.Add./Output Self%&. Self%& Rhs&. Rhs&)
   ))
   :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_pre_post_definition
)))

;; Function-Specs core::ops::arith::Add::add
(declare-fun req%core!ops.arith.Add.add. (Dcr Type Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (= (req%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs!) (=>
     %%global_location_label%%6
     (%B (vstd!std_specs.ops.AddSpec.add_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   ))
   :pattern ((req%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_req__core!ops.arith.Add.add._definition
   :skolemid skolem_internal_req__core!ops.arith.Add.add._definition
)))
(declare-fun ens%core!ops.arith.Add.add. (Dcr Type Dcr Type Poly Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly)
   (ret! Poly)
  ) (!
   (= (ens%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!) (and
     (has_type ret! (proj%core!ops.arith.Add./Output Self%&. Self%& Rhs&. Rhs&))
     (=>
      (%B (vstd!std_specs.ops.AddSpec.obeys_add_spec.? Self%&. Self%& Rhs&. Rhs&))
      (= ret! (vstd!std_specs.ops.AddSpec.add_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   )))
   :pattern ((ens%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!))
   :qid internal_ens__core!ops.arith.Add.add._definition
   :skolemid skolem_internal_ens__core!ops.arith.Add.add._definition
)))

;; Function-Axioms vstd::std_specs::option::OptionAdditionalFns::arrow_0
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!std_specs.option.OptionAdditionalFns.arrow_0.? Self%&. Self%& T&. T&
      self!
     ) T&
   ))
   :pattern ((vstd!std_specs.option.OptionAdditionalFns.arrow_0.? Self%&. Self%& T&. T&
     self!
   ))
   :qid internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::option::is_some
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.is_some.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.is_some.)
  (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
    (= (vstd!std_specs.option.is_some.? T&. T& option!) (is-core!option.Option./Some (%Poly%core!option.Option.
       option!
    )))
    :pattern ((vstd!std_specs.option.is_some.? T&. T& option!))
    :qid internal_vstd!std_specs.option.is_some.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.is_some.?_definition
))))

;; Function-Axioms vstd::std_specs::option::is_none
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.is_none.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.is_none.)
  (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
    (= (vstd!std_specs.option.is_none.? T&. T& option!) (is-core!option.Option./None (%Poly%core!option.Option.
       option!
    )))
    :pattern ((vstd!std_specs.option.is_none.? T&. T& option!))
    :qid internal_vstd!std_specs.option.is_none.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.is_none.?_definition
))))

;; Function-Axioms vstd::std_specs::option::impl&%0::arrow_0
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.impl&%0.arrow_0.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.impl&%0.arrow_0.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!std_specs.option.OptionAdditionalFns.arrow_0.? $ (TYPE%core!option.Option.
        T&. T&
       ) T&. T& self!
      ) (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option. self!))
    ))
    :pattern ((vstd!std_specs.option.OptionAdditionalFns.arrow_0.? $ (TYPE%core!option.Option.
       T&. T&
      ) T&. T& self!
    ))
    :qid internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!std_specs.option.OptionAdditionalFns. $ (TYPE%core!option.Option. T&.
      T&
     ) T&. T&
   ))
   :pattern ((tr_bound%vstd!std_specs.option.OptionAdditionalFns. $ (TYPE%core!option.Option.
      T&. T&
     ) T&. T&
   ))
   :qid internal_vstd__std_specs__option__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__option__impl&__0_trait_impl_definition
)))

;; Function-Specs vstd::std_specs::option::spec_unwrap
(declare-fun req%vstd!std_specs.option.spec_unwrap. (Dcr Type Poly) Bool)
(declare-const %%global_location_label%%7 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
   (= (req%vstd!std_specs.option.spec_unwrap. T&. T& option!) (=>
     %%global_location_label%%7
     (is-core!option.Option./Some (%Poly%core!option.Option. option!))
   ))
   :pattern ((req%vstd!std_specs.option.spec_unwrap. T&. T& option!))
   :qid internal_req__vstd!std_specs.option.spec_unwrap._definition
   :skolemid skolem_internal_req__vstd!std_specs.option.spec_unwrap._definition
)))

;; Function-Axioms vstd::std_specs::option::spec_unwrap
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.spec_unwrap.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.spec_unwrap.)
  (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
    (= (vstd!std_specs.option.spec_unwrap.? T&. T& option!) (core!option.Option./Some/0
      T&. T& (%Poly%core!option.Option. option!)
    ))
    :pattern ((vstd!std_specs.option.spec_unwrap.? T&. T& option!))
    :qid internal_vstd!std_specs.option.spec_unwrap.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.spec_unwrap.?_definition
))))
(assert
 (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
   (=>
    (has_type option! (TYPE%core!option.Option. T&. T&))
    (has_type (vstd!std_specs.option.spec_unwrap.? T&. T& option!) T&)
   )
   :pattern ((vstd!std_specs.option.spec_unwrap.? T&. T& option!))
   :qid internal_vstd!std_specs.option.spec_unwrap.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.option.spec_unwrap.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::option::spec_unwrap_or
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.spec_unwrap_or.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.spec_unwrap_or.)
  (forall ((T&. Dcr) (T& Type) (option! Poly) (default! Poly)) (!
    (= (vstd!std_specs.option.spec_unwrap_or.? T&. T& option! default!) (ite
      (is-core!option.Option./Some (%Poly%core!option.Option. option!))
      (let
       ((t$ (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option. option!))))
       t$
      )
      default!
    ))
    :pattern ((vstd!std_specs.option.spec_unwrap_or.? T&. T& option! default!))
    :qid internal_vstd!std_specs.option.spec_unwrap_or.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.spec_unwrap_or.?_definition
))))
(assert
 (forall ((T&. Dcr) (T& Type) (option! Poly) (default! Poly)) (!
   (=>
    (and
     (has_type option! (TYPE%core!option.Option. T&. T&))
     (has_type default! T&)
    )
    (has_type (vstd!std_specs.option.spec_unwrap_or.? T&. T& option! default!) T&)
   )
   :pattern ((vstd!std_specs.option.spec_unwrap_or.? T&. T& option! default!))
   :qid internal_vstd!std_specs.option.spec_unwrap_or.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.option.spec_unwrap_or.?_pre_post_definition
)))

;; Function-Specs core::option::impl&%5::clone
(declare-fun ens%core!option.impl&%5.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (opt! Poly) (res! Poly)) (!
   (= (ens%core!option.impl&%5.clone. T&. T& opt! res!) (and
     (ens%core!clone.Clone.clone. $ (TYPE%core!option.Option. T&. T&) opt! res!)
     (=>
      (is-core!option.Option./None (%Poly%core!option.Option. opt!))
      (is-core!option.Option./None (%Poly%core!option.Option. res!))
     )
     (=>
      (is-core!option.Option./Some (%Poly%core!option.Option. opt!))
      (and
       (is-core!option.Option./Some (%Poly%core!option.Option. res!))
       (vstd!pervasive.cloned.? T&. T& (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option.
          opt!
         )
        ) (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option. res!))
   )))))
   :pattern ((ens%core!option.impl&%5.clone. T&. T& opt! res!))
   :qid internal_ens__core!option.impl&__5.clone._definition
   :skolemid skolem_internal_ens__core!option.impl&__5.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (TYPE%core!option.Option. T&. T&)))
     (has_type res$ (TYPE%core!option.Option. T&. T&))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (TYPE%core!option.Option. T&. T&)) (
       DST (REF $)
      ) (TYPE%tuple%1. (REF $) (TYPE%core!option.Option. T&. T&)) (F fndef_singleton) closure%$
      res$
     )
     (let
      ((opt$ (%Poly%core!option.Option. (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (and
       (=>
        (is-core!option.Option./None opt$)
        (is-core!option.Option./None (%Poly%core!option.Option. res$))
       )
       (=>
        (is-core!option.Option./Some opt$)
        (and
         (is-core!option.Option./Some (%Poly%core!option.Option. res$))
         (vstd!pervasive.cloned.? T&. T& (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option.
            (Poly%core!option.Option. opt$)
           )
          ) (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option. res$))
   )))))))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (TYPE%core!option.Option. T&.
       T&
      )
     ) (DST (REF $)) (TYPE%tuple%1. (REF $) (TYPE%core!option.Option. T&. T&)) (F fndef_singleton)
     closure%$ res$
   ))
   :qid user_core__option__impl&%5__clone_68
   :skolemid skolem_user_core__option__impl&%5__clone_68
)))

;; Function-Specs core::iter::range::impl&%6::next
(declare-fun ens%core!iter.range.impl&%6.next. (Dcr Type Poly Poly Poly) Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (pre%range! Poly) (range! Poly) (r! Poly)) (!
   (= (ens%core!iter.range.impl&%6.next. A&. A& pre%range! range! r!) (and
     (ens%core!iter.traits.iterator.Iterator.next. $ (TYPE%core!ops.range.Range. A&. A&)
      pre%range! range! r!
     )
     (= (tuple%2./tuple%2 range! r!) (vstd!std_specs.range.spec_range_next.? A&. A& pre%range!))
   ))
   :pattern ((ens%core!iter.range.impl&%6.next. A&. A& pre%range! range! r!))
   :qid internal_ens__core!iter.range.impl&__6.next._definition
   :skolemid skolem_internal_ens__core!iter.range.impl&__6.next._definition
)))

;; Function-Axioms vstd::pervasive::FnWithRequiresEnsures::ensures
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Args&. Dcr) (Args& Type) (Output&. Dcr) (Output&
    Type
   ) (self! Poly) (args! Poly) (output! Poly)
  ) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type args! Args&)
     (has_type output! Output&)
    )
    (has_type (vstd!pervasive.FnWithRequiresEnsures.ensures.? Self%&. Self%& Args&. Args&
      Output&. Output& self! args! output!
     ) BOOL
   ))
   :pattern ((vstd!pervasive.FnWithRequiresEnsures.ensures.? Self%&. Self%& Args&. Args&
     Output&. Output& self! args! output!
   ))
   :qid internal_vstd!pervasive.FnWithRequiresEnsures.ensures.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.FnWithRequiresEnsures.ensures.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::impl&%0::ensures
(assert
 (fuel_bool_default fuel%vstd!pervasive.impl&%0.ensures.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!pervasive.impl&%0.ensures.)
  (forall ((Args&. Dcr) (Args& Type) (Output&. Dcr) (Output& Type) (F&. Dcr) (F& Type)
    (self! Poly) (args! Poly) (output! Poly)
   ) (!
    (=>
     (and
      (sized Output&.)
      (sized F&.)
      (sized Args&.)
     )
     (= (vstd!pervasive.FnWithRequiresEnsures.ensures.? F&. F& Args&. Args& Output&. Output&
       self! args! output!
      ) (B (closure_ens F& Args&. Args& self! args! output!))
    ))
    :pattern ((vstd!pervasive.FnWithRequiresEnsures.ensures.? F&. F& Args&. Args& Output&.
      Output& self! args! output!
    ))
    :qid internal_vstd!pervasive.FnWithRequiresEnsures.ensures.?_definition
    :skolemid skolem_internal_vstd!pervasive.FnWithRequiresEnsures.ensures.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((Args&. Dcr) (Args& Type) (Output&. Dcr) (Output& Type) (F&. Dcr) (F& Type))
  (!
   (=>
    (and
     (sized Output&.)
     (sized F&.)
     (sized Args&.)
    )
    (tr_bound%vstd!pervasive.FnWithRequiresEnsures. F&. F& Args&. Args& Output&. Output&)
   )
   :pattern ((tr_bound%vstd!pervasive.FnWithRequiresEnsures. F&. F& Args&. Args& Output&.
     Output&
   ))
   :qid internal_vstd__pervasive__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__pervasive__impl&__0_trait_impl_definition
)))

;; Function-Specs alloc::boxed::impl&%9::default
(declare-fun ens%alloc!boxed.impl&%9.default. (Dcr Type Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (res! Poly)) (!
   (= (ens%alloc!boxed.impl&%9.default. T&. T& res!) (and
     (ens%core!default.Default.default. (BOX $ ALLOCATOR_GLOBAL T&.) T& res!)
     (closure_ens (FNDEF%core!default.Default.default. T&. T&) $ TYPE%tuple%0. (F fndef_singleton)
      (Poly%tuple%0. tuple%0./tuple%0) res!
   )))
   :pattern ((ens%alloc!boxed.impl&%9.default. T&. T& res!))
   :qid internal_ens__alloc!boxed.impl&__9.default._definition
   :skolemid skolem_internal_ens__alloc!boxed.impl&__9.default._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. (BOX $ ALLOCATOR_GLOBAL T&.) T&)
      $ TYPE%tuple%0. (F fndef_singleton) closure%$ res$
     )
     (closure_ens (FNDEF%core!default.Default.default. T&. T&) $ TYPE%tuple%0. (F fndef_singleton)
      (Poly%tuple%0. tuple%0./tuple%0) res$
   )))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. (BOX $ ALLOCATOR_GLOBAL T&.)
      T&
     ) $ TYPE%tuple%0. (F fndef_singleton) closure%$ res$
   ))
   :qid user_alloc__boxed__impl&%9__default_69
   :skolemid skolem_user_alloc__boxed__impl&%9__default_69
)))

;; Function-Specs alloc::rc::impl&%36::default
(declare-fun ens%alloc!rc.impl&%36.default. (Dcr Type Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (res! Poly)) (!
   (= (ens%alloc!rc.impl&%36.default. T&. T& res!) (and
     (ens%core!default.Default.default. (RC $ ALLOCATOR_GLOBAL T&.) T& res!)
     (closure_ens (FNDEF%core!default.Default.default. T&. T&) $ TYPE%tuple%0. (F fndef_singleton)
      (Poly%tuple%0. tuple%0./tuple%0) res!
   )))
   :pattern ((ens%alloc!rc.impl&%36.default. T&. T& res!))
   :qid internal_ens__alloc!rc.impl&__36.default._definition
   :skolemid skolem_internal_ens__alloc!rc.impl&__36.default._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. (RC $ ALLOCATOR_GLOBAL T&.) T&)
      $ TYPE%tuple%0. (F fndef_singleton) closure%$ res$
     )
     (closure_ens (FNDEF%core!default.Default.default. T&. T&) $ TYPE%tuple%0. (F fndef_singleton)
      (Poly%tuple%0. tuple%0./tuple%0) res$
   )))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. (RC $ ALLOCATOR_GLOBAL T&.)
      T&
     ) $ TYPE%tuple%0. (F fndef_singleton) closure%$ res$
   ))
   :qid user_alloc__rc__impl&%36__default_70
   :skolemid skolem_user_alloc__rc__impl&%36__default_70
)))

;; Function-Specs alloc::sync::impl&%60::default
(declare-fun ens%alloc!sync.impl&%60.default. (Dcr Type Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (res! Poly)) (!
   (= (ens%alloc!sync.impl&%60.default. T&. T& res!) (and
     (ens%core!default.Default.default. (ARC $ ALLOCATOR_GLOBAL T&.) T& res!)
     (closure_ens (FNDEF%core!default.Default.default. T&. T&) $ TYPE%tuple%0. (F fndef_singleton)
      (Poly%tuple%0. tuple%0./tuple%0) res!
   )))
   :pattern ((ens%alloc!sync.impl&%60.default. T&. T& res!))
   :qid internal_ens__alloc!sync.impl&__60.default._definition
   :skolemid skolem_internal_ens__alloc!sync.impl&__60.default._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. (ARC $ ALLOCATOR_GLOBAL T&.) T&)
      $ TYPE%tuple%0. (F fndef_singleton) closure%$ res$
     )
     (closure_ens (FNDEF%core!default.Default.default. T&. T&) $ TYPE%tuple%0. (F fndef_singleton)
      (Poly%tuple%0. tuple%0./tuple%0) res$
   )))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. (ARC $ ALLOCATOR_GLOBAL T&.)
      T&
     ) $ TYPE%tuple%0. (F fndef_singleton) closure%$ res$
   ))
   :qid user_alloc__sync__impl&%60__default_71
   :skolemid skolem_user_alloc__sync__impl&%60__default_71
)))

;; Function-Specs alloc::boxed::impl&%13::clone
(declare-fun ens%alloc!boxed.impl&%13.clone. (Dcr Type Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type) (b! Poly) (res! Poly)) (!
   (= (ens%alloc!boxed.impl&%13.clone. T&. T& A&. A& b! res!) (and
     (ens%core!clone.Clone.clone. (BOX A&. A& T&.) T& b! res!)
     (vstd!pervasive.cloned.? T&. T& b! res!)
   ))
   :pattern ((ens%alloc!boxed.impl&%13.clone. T&. T& A&. A& b! res!))
   :qid internal_ens__alloc!boxed.impl&__13.clone._definition
   :skolemid skolem_internal_ens__alloc!boxed.impl&__13.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (BOX A&. A& T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (BOX A&. A& T&.) T&) (DST (REF (BOX A&. A&
         T&.
       ))
      ) (TYPE%tuple%1. (REF (BOX A&. A& T&.)) T&) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (vstd!pervasive.cloned.? T&. T& b$ res$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (BOX A&. A& T&.) T&) (DST (REF
       (BOX A&. A& T&.)
      )
     ) (TYPE%tuple%1. (REF (BOX A&. A& T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_alloc__boxed__impl&%13__clone_72
   :skolemid skolem_user_alloc__boxed__impl&%13__clone_72
)))

;; Function-Specs vstd::array::array_index_get
(declare-fun req%vstd!array.array_index_get. (Dcr Type Dcr Type %%Function%% Int)
 Bool
)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! %%Function%%) (i! Int)) (!
   (= (req%vstd!array.array_index_get. T&. T& N&. N& ar! i!) (=>
     %%global_location_label%%8
     (let
      ((tmp%%$ i!))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (const_int N&))
   ))))
   :pattern ((req%vstd!array.array_index_get. T&. T& N&. N& ar! i!))
   :qid internal_req__vstd!array.array_index_get._definition
   :skolemid skolem_internal_req__vstd!array.array_index_get._definition
)))
(declare-fun ens%vstd!array.array_index_get. (Dcr Type Dcr Type %%Function%% Int Poly)
 Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! %%Function%%) (i! Int) (out! Poly))
  (!
   (= (ens%vstd!array.array_index_get. T&. T& N&. N& ar! i! out!) (and
     (has_type out! T&)
     (= out! (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
        (Poly%array%. ar!)
       ) (I i!)
   ))))
   :pattern ((ens%vstd!array.array_index_get. T&. T& N&. N& ar! i! out!))
   :qid internal_ens__vstd!array.array_index_get._definition
   :skolemid skolem_internal_ens__vstd!array.array_index_get._definition
)))

;; Function-Specs vstd::array::array_fill_for_copy_types
(declare-fun ens%vstd!array.array_fill_for_copy_types. (Dcr Type Dcr Type Poly %%Function%%)
 Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (t! Poly) (res! %%Function%%)) (!
   (= (ens%vstd!array.array_fill_for_copy_types. T&. T& N&. N& t! res!) (and
     (has_type (Poly%array%. res!) (ARRAY T&. T& N&. N&))
     (= res! (vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!))
   ))
   :pattern ((ens%vstd!array.array_fill_for_copy_types. T&. T& N&. N& t! res!))
   :qid internal_ens__vstd!array.array_fill_for_copy_types._definition
   :skolemid skolem_internal_ens__vstd!array.array_fill_for_copy_types._definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::exec_invariant
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (exec_iter! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type exec_iter! (proj%vstd!pervasive.ForLoopGhostIterator./ExecIter Self%&. Self%&))
    )
    (has_type (vstd!pervasive.ForLoopGhostIterator.exec_invariant.? Self%&. Self%& self!
      exec_iter!
     ) BOOL
   ))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.exec_invariant.? Self%&. Self%& self!
     exec_iter!
   ))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.exec_invariant.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.exec_invariant.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::ghost_invariant
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (init! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type init! (TYPE%core!option.Option. (REF Self%&.) Self%&))
    )
    (has_type (vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? Self%&. Self%& self!
      init!
     ) BOOL
   ))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? Self%&. Self%& self!
     init!
   ))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_invariant.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_invariant.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::ghost_ensures
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? Self%&. Self%& self!)
     BOOL
   ))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? Self%&. Self%& self!))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_ensures.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_ensures.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::ghost_decrease
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!pervasive.ForLoopGhostIterator.ghost_decrease.? Self%&. Self%& self!)
     (TYPE%core!option.Option. (proj%%vstd!pervasive.ForLoopGhostIterator./Decrease Self%&.
       Self%&
      ) (proj%vstd!pervasive.ForLoopGhostIterator./Decrease Self%&. Self%&)
   )))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_decrease.? Self%&. Self%& self!))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::ghost_peek_next
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.? Self%&. Self%& self!)
     (TYPE%core!option.Option. (proj%%vstd!pervasive.ForLoopGhostIterator./Item Self%&.
       Self%&
      ) (proj%vstd!pervasive.ForLoopGhostIterator./Item Self%&. Self%&)
   )))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.? Self%&. Self%& self!))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::ghost_advance
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (exec_iter! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type exec_iter! (proj%vstd!pervasive.ForLoopGhostIterator./ExecIter Self%&. Self%&))
    )
    (has_type (vstd!pervasive.ForLoopGhostIterator.ghost_advance.? Self%&. Self%& self!
      exec_iter!
     ) Self%&
   ))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_advance.? Self%&. Self%& self!
     exec_iter!
   ))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_advance.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_advance.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIteratorNew::ghost_iter
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? Self%&. Self%& self!)
     (proj%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter Self%&. Self%&)
   ))
   :pattern ((vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? Self%&. Self%& self!))
   :qid internal_vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::arbitrary
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (has_type (vstd!pervasive.arbitrary.? A&. A&) A&)
   :pattern ((vstd!pervasive.arbitrary.? A&. A&))
   :qid internal_vstd!pervasive.arbitrary.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.arbitrary.?_pre_post_definition
)))

;; Function-Axioms vstd::raw_ptr::impl&%3::view
(assert
 (fuel_bool_default fuel%vstd!raw_ptr.impl&%3.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.impl&%3.view.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (= (vstd!view.View.view.? (CONST_PTR $) (PTR T&. T&) self!) (vstd!view.View.view.?
      $ (PTR T&. T&) self!
    ))
    :pattern ((vstd!view.View.view.? (CONST_PTR $) (PTR T&. T&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%vstd!view.View. (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%vstd!view.View. (CONST_PTR $) (PTR T&. T&)))
   :qid internal_vstd__raw_ptr__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__raw_ptr__impl&__3_trait_impl_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::p
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.p.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.p.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.p.? no%param) (nClip (Sub (vstd!arithmetic.power2.pow2.?
        (I 255)
       ) 19
    )))
    :pattern ((curve25519_dalek!specs.field_specs_u64.p.? no%param))
    :qid internal_curve25519_dalek!specs.field_specs_u64.p.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.p.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.field_specs_u64.p.? no%param))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.p.? no%param))
   :qid internal_curve25519_dalek!specs.field_specs_u64.p.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.p.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::field_canonical
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.)
  (forall ((n! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? n!) (EucMod (%I n!) (curve25519_dalek!specs.field_specs_u64.p.?
       (I 0)
    )))
    :pattern ((curve25519_dalek!specs.field_specs_u64.field_canonical.? n!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_definition
))))
(assert
 (forall ((n! Poly)) (!
   (=>
    (has_type n! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs_u64.field_canonical.? n!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.field_canonical.? n!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::u64_5_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!) (nClip (Add (nClip
        (Add (nClip (Add (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
               ) (I 0)
              )
             ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 51)) (%I (vstd!seq.Seq.index.? $ (UINT
                  64
                 ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 1)
            )))))
           ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 102)) (%I (vstd!seq.Seq.index.? $ (UINT
                64
               ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 2)
          )))))
         ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 153)) (%I (vstd!seq.Seq.index.? $ (UINT
              64
             ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 3)
        )))))
       ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 204)) (%I (vstd!seq.Seq.index.? $ (UINT
            64
           ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 4)
    )))))))
    :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (<= 0 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::u64_5_as_field_canonical
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (<= 0 (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_as_canonical_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.)
  (forall ((fe! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!) (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?
      (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
    ))))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_definition
))))
(assert
 (forall ((fe! Poly)) (!
   (=>
    (has_type fe! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (<= 0 (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!))
   :qid internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_x
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_x.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_x.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_x.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_x.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_y
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_y.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_y.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_y.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_y.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_z
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_z.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_z.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_z.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_z.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_t
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_t.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_t.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_t.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_t.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_point_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!) (let
      ((x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_x.? point!)
      ))))
      (let
       ((y$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
       ))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!specs.edwards_specs.edwards_z.? point!)
        ))))
        (let
         ((t$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!specs.edwards_specs.edwards_t.? point!)
         ))))
         (tuple%4./tuple%4 (I x$) (I y$) (I z$) (I t$))
    )))))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%tuple%4. (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?
       point!
      )
     ) (TYPE%tuple%4. $ NAT $ NAT $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_gcd
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
 Fuel
)
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b!
     fuel%
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b!
     zero
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_zero_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b!
      (succ fuel%)
     ) (ite
      (= (%I b!) 0)
      (%I a!)
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? b! (I (EucMod
         (%I a!) (%I b!)
        )
       ) fuel%
   ))))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
     a! b! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.)
  (forall ((a! Poly) (b! Poly)) (!
    (=>
     (and
      (has_type a! NAT)
      (has_type b! NAT)
     )
     (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a! b!) (
       curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b! (
        succ fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
    ))))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a!
      b!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a! b!))
   )
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a!
     b!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_pre_post_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a!
      b! fuel%
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_gcd.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_gcd.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_extended_gcd
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
 Fuel
)
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! fuel%
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! zero
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_zero_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
      a! b! (succ fuel%)
     ) (ite
      (= (%I b!) 0)
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
       (%I a!) (%I (I 1)) (%I (I 0))
      )
      (let
       ((r$ (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
          b! (I (EucMod (%I a!) (%I b!))) fuel%
       )))
       (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
        (%I (I (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
           (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
             r$
         ))))
        ) (%I (I (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
           (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
             r$
         ))))
        ) (%I (I (Sub (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
            (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
              r$
            ))
           ) (Mul (EucDiv (%I a!) (%I b!)) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
             (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
               r$
   ))))))))))))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.)
  (forall ((a! Poly) (b! Poly)) (!
    (=>
     (and
      (has_type a! NAT)
      (has_type b! NAT)
     )
     (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
       a! b!
      ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
       a! b! (succ fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.)
    )))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
      a! b!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.? a!
       b!
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
     a! b!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_pre_post_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
       a! b! fuel%
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_extended_gcd.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_extended_gcd.?_pre_post_rec_definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_mod_inverse
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
 (Poly Poly) Bool
)
(declare-const %%global_location_label%%9 Bool)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((a! Poly) (m! Poly)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
     a! m!
    ) (and
     (=>
      %%global_location_label%%9
      (> (%I m!) 1)
     )
     (=>
      %%global_location_label%%10
      (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? (I (EucMod
          (%I a!) (%I m!)
         )
        ) m!
       ) 1
   ))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
     a! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse._definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_mod_inverse
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.)
  (forall ((a! Poly) (m! Poly)) (!
    (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.? a!
      m!
     ) (ite
      (or
       (<= (%I m!) 1)
       (not (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? (I (EucMod
            (%I a!) (%I m!)
           )
          ) m!
         ) 1
      )))
      0
      (let
       ((r$ (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
          (I (EucMod (%I a!) (%I m!))) m!
       )))
       (nClip (EucMod (Add (EucMod (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
            (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
              r$
            ))
           ) (%I m!)
          ) (%I m!)
         ) (%I m!)
    )))))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
      a! m!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_definition
))))
(assert
 (forall ((a! Poly) (m! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type m! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
      a! m!
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
     a! m!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_inv
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_inv.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_inv.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_inv.? a!) (ite
      (= (EucMod (%I a!) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0)
      0
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.? a!
       (I (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
    )))
    :pattern ((curve25519_dalek!specs.field_specs.field_inv.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_inv.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_inv.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_inv.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_inv.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_inv.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_inv.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_mul
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_mul.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_mul.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_mul.? a! b!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Mul (%I a!) (%I b!))))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_mul.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.field_mul.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_mul.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!specs.field_specs.field_mul.? a! b!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_mul.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.field_mul.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_mul.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_point_as_affine
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? point!) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((_t$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (let
           ((z_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I z$))))
           (tuple%2./tuple%2 (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I z_inv$)))
            (I (curve25519_dalek!specs.field_specs.field_mul.? (I y$) (I z_inv$)))
    ))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
       point!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_pre_post_definition
)))

;; Function-Specs subtle::impl&%9::from
(declare-fun ens%subtle!impl&%9.from. (Poly Poly) Bool)
(assert
 (forall ((u! Poly) (c! Poly)) (!
   (= (ens%subtle!impl&%9.from. u! c!) (and
     (ens%core!convert.From.from. $ TYPE%subtle!Choice. $ (UINT 8) u! c!)
     (= (= (%I u!) 1) (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.?
       c!
   ))))
   :pattern ((ens%subtle!impl&%9.from. u! c!))
   :qid internal_ens__subtle!impl&__9.from._definition
   :skolemid skolem_internal_ens__subtle!impl&__9.from._definition
)))
(assert
 (forall ((closure%$ Poly) (c$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. $ (UINT 8)))
     (has_type c$ TYPE%subtle!Choice.)
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ TYPE%subtle!Choice. $ (UINT 8)) (DST
       $
      ) (TYPE%tuple%1. $ (UINT 8)) (F fndef_singleton) closure%$ c$
     )
     (let
      ((u$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (= u$ 1) (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? c$))
   )))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ TYPE%subtle!Choice. $ (UINT 8))
     (DST $) (TYPE%tuple%1. $ (UINT 8)) (F fndef_singleton) closure%$ c$
   ))
   :qid user_subtle__impl&%9__from_73
   :skolemid skolem_user_subtle__impl&%9__from_73
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::subtle_assumes::ct_eq_u16
(declare-fun ens%curve25519_dalek!backend.serial.u64.subtle_assumes.ct_eq_u16. (Int
  Int subtle!Choice.
 ) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! subtle!Choice.)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.subtle_assumes.ct_eq_u16. a! b! c!) (=
     (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
       c!
      )
     ) (= a! b!)
   ))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.subtle_assumes.ct_eq_u16. a! b!
     c!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.ct_eq_u16._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.ct_eq_u16._definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::u64_5_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.u64_5_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.u64_5_bounded.)
  (forall ((limbs! Poly) (bit_limit! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.u64_5_bounded.? limbs! bit_limit!) (forall (
       (i$ Poly)
      ) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 5)
         ))
         (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) limbs!
            ) i$
           )
          ) (uClip 64 (bitshl (I 1) (I (%I bit_limit!))))
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) limbs!
         ) i$
       ))
       :qid user_curve25519_dalek__specs__field_specs__u64_5_bounded_74
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__u64_5_bounded_74
    )))
    :pattern ((curve25519_dalek!specs.field_specs.u64_5_bounded.? limbs! bit_limit!))
    :qid internal_curve25519_dalek!specs.field_specs.u64_5_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.u64_5_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded.)
  (forall ((fe! Poly) (bit_limit! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? fe! bit_limit!) (curve25519_dalek!specs.field_specs.u64_5_bounded.?
      (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
       )
      ) bit_limit!
    ))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? fe! bit_limit!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::mask51
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.mask51.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.mask51.)
  (= curve25519_dalek!specs.field_specs_u64.mask51.? 2251799813685247)
))
(assert
 (uInv 64 curve25519_dalek!specs.field_specs_u64.mask51.?)
)

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::spec_reduce
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce.)
)
(declare-fun %%array%%0 (Poly Poly Poly Poly Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Poly) (%%hole%%1 Poly) (%%hole%%2 Poly) (%%hole%%3 Poly) (%%hole%%4
    Poly
   )
  ) (!
   (let
    ((%%x%% (%%array%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4)))
    (and
     (= (%%apply%%1 %%x%% 0) %%hole%%0)
     (= (%%apply%%1 %%x%% 1) %%hole%%1)
     (= (%%apply%%1 %%x%% 2) %%hole%%2)
     (= (%%apply%%1 %%x%% 3) %%hole%%3)
     (= (%%apply%%1 %%x%% 4) %%hole%%4)
   ))
   :pattern ((%%array%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4))
   :qid __AIR_ARRAY_QID__
   :skolemid skolem___AIR_ARRAY_QID__
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!) (let
      ((r$ (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Add (uClip 64 (bitand
                (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                     (CONST_INT 5)
                    ) limbs!
                   ) (I 0)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (Mul (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                     $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                    ) (I 4)
                  ))
                 ) (I 51)
                )
               ) 19
            )))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 1)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 0)
                 ))
                ) (I 51)
            ))))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 2)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 1)
                 ))
                ) (I 51)
            ))))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 3)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 2)
                 ))
                ) (I 51)
            ))))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 4)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 3)
                 ))
                ) (I 51)
      ))))))))))
      r$
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!))
     (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::sixteen_p_vec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.)
  (= curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.? (%Poly%array%. (array_new
     $ (UINT 64) 5 (%%array%%0 (I 36028797018963664) (I 36028797018963952) (I 36028797018963952)
      (I 36028797018963952) (I 36028797018963952)
))))))
(assert
 (has_type (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?) (ARRAY
   $ (UINT 64) $ (CONST_INT 5)
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::pre_reduce_limbs
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!) (let
      ((r$ (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.?
                $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
                  curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?
                 )
                ) (I 0)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 0)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 1)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 1)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 2)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 2)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 3)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 3)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 4)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 4)
      ))))))))))
      r$
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!))
     (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::spec_negate
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.spec_negate.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.spec_negate.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!) (let
      ((r$ (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?
           limbs!
      )))))
      r$
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!))
     (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::negate_affine_niels
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.negate_affine_niels.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.negate_affine_niels.)
  (forall ((p! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.negate_affine_niels.? p!) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint
      (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
         (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. p!)
       ))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
         (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. p!)
       ))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
              (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
                 (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. p!)
    )))))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.negate_affine_niels.? p!))
    :qid internal_curve25519_dalek!specs.edwards_specs.negate_affine_niels.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.negate_affine_niels.?_definition
))))
(assert
 (forall ((p! Poly)) (!
   (=>
    (has_type p! TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (curve25519_dalek!specs.edwards_specs.negate_affine_niels.?
       p!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.negate_affine_niels.? p!))
   :qid internal_curve25519_dalek!specs.edwards_specs.negate_affine_niels.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.negate_affine_niels.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::subtle_assumes::conditional_negate_affine_niels
(declare-fun req%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_affine_niels.
 (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. subtle!Choice.) Bool
)
(declare-const %%global_location_label%%11 Bool)
(declare-const %%global_location_label%%12 Bool)
(declare-const %%global_location_label%%13 Bool)
(assert
 (forall ((pre%a! curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.) (choice!
    subtle!Choice.
   )
  ) (!
   (= (req%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_affine_niels.
     pre%a! choice!
    ) (and
     (=>
      %%global_location_label%%11
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
         (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           pre%a!
        )))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%12
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
         (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           pre%a!
        )))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%13
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
         (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           pre%a!
        )))
       ) (I 54)
   ))))
   :pattern ((req%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_affine_niels.
     pre%a! choice!
   ))
   :qid internal_req__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_affine_niels._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_affine_niels._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_affine_niels.
 (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
  subtle!Choice.
 ) Bool
)
(assert
 (forall ((pre%a! curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.) (a!
    curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
   ) (choice! subtle!Choice.)
  ) (!
   (= (ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_affine_niels.
     pre%a! a! choice!
    ) (and
     (has_type (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. a!)
      TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
     )
     (=>
      (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         choice!
      )))
      (= a! pre%a!)
     )
     (=>
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        choice!
      ))
      (= a! (curve25519_dalek!specs.edwards_specs.negate_affine_niels.? (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
         pre%a!
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
        (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
          a!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
        (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
          a!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
        (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
          a!
       )))
      ) (I 54)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_affine_niels.
     pre%a! a! choice!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_affine_niels._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_affine_niels._definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::negate_projective_niels
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.negate_projective_niels.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.negate_projective_niels.)
  (forall ((p! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.negate_projective_niels.? p!) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
      (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. p!)
       ))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. p!)
       ))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. p!)
       ))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
              (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
                 (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. p!)
    )))))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.negate_projective_niels.? p!))
    :qid internal_curve25519_dalek!specs.edwards_specs.negate_projective_niels.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.negate_projective_niels.?_definition
))))
(assert
 (forall ((p! Poly)) (!
   (=>
    (has_type p! TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!specs.edwards_specs.negate_projective_niels.? p!)
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.negate_projective_niels.? p!))
   :qid internal_curve25519_dalek!specs.edwards_specs.negate_projective_niels.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.negate_projective_niels.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::subtle_assumes::conditional_negate_projective_niels
(declare-fun req%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_projective_niels.
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. subtle!Choice.)
 Bool
)
(declare-const %%global_location_label%%14 Bool)
(declare-const %%global_location_label%%15 Bool)
(declare-const %%global_location_label%%16 Bool)
(declare-const %%global_location_label%%17 Bool)
(assert
 (forall ((pre%a! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   (choice! subtle!Choice.)
  ) (!
   (= (req%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_projective_niels.
     pre%a! choice!
    ) (and
     (=>
      %%global_location_label%%14
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           pre%a!
        )))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%15
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           pre%a!
        )))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%16
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           pre%a!
        )))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%17
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           pre%a!
        )))
       ) (I 54)
   ))))
   :pattern ((req%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_projective_niels.
     pre%a! choice!
   ))
   :qid internal_req__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_projective_niels._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_projective_niels._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_projective_niels.
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  subtle!Choice.
 ) Bool
)
(assert
 (forall ((pre%a! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   (a! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) (choice! subtle!Choice.)
  ) (!
   (= (ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_projective_niels.
     pre%a! a! choice!
    ) (and
     (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       a!
      ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
     )
     (=>
      (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         choice!
      )))
      (= a! pre%a!)
     )
     (=>
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        choice!
      ))
      (= a! (curve25519_dalek!specs.edwards_specs.negate_projective_niels.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         pre%a!
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          a!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          a!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          a!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          a!
       )))
      ) (I 54)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_projective_niels.
     pre%a! a! choice!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_projective_niels._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_negate_projective_niels._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::subtle_assumes::conditional_assign_generic
(declare-fun ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_assign_generic.
 (Dcr Type Poly Poly Poly subtle!Choice.) Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (pre%a! Poly) (a! Poly) (b! Poly) (choice! subtle!Choice.))
  (!
   (= (ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_assign_generic.
     T&. T& pre%a! a! b! choice!
    ) (and
     (has_type a! T&)
     (=>
      (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         choice!
      )))
      (= a! pre%a!)
     )
     (=>
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        choice!
      ))
      (= a! b!)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_assign_generic.
     T&. T& pre%a! a! b! choice!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_assign_generic._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_assign_generic._definition
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::EDWARDS_D
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.)
  (= curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 929955233495203) (I 466365720129213)
       (I 1662059464998953) (I 2033849074728123) (I 1442794654840575)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_square
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_square.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_square.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_square.? a!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Mul (%I a!) (%I a!))))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_square.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_square.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_square.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_square.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_square.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_square.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_square.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_sub
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_sub.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_sub.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_sub.? a! b!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Sub (nClip (Add (curve25519_dalek!specs.field_specs_u64.field_canonical.? a!)
           (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
          )
         ) (curve25519_dalek!specs.field_specs_u64.field_canonical.? b!)
    )))))
    :pattern ((curve25519_dalek!specs.field_specs.field_sub.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.field_sub.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_sub.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!specs.field_specs.field_sub.? a! b!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_sub.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.field_sub.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_sub.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_add
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_add.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_add.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_add.? a! b!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Add (%I a!) (%I b!))))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_add.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.field_add.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_add.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!specs.field_specs.field_add.? a! b!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_add.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.field_add.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_add.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_on_edwards_curve_projective
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.)
  (forall ((x! Poly) (y! Poly) (z! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? x! y! z!)
     (let
      ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
      ))))
      (let
       ((x2$ (curve25519_dalek!specs.field_specs.field_square.? x!)))
       (let
        ((y2$ (curve25519_dalek!specs.field_specs.field_square.? y!)))
        (let
         ((z2$ (curve25519_dalek!specs.field_specs.field_square.? z!)))
         (let
          ((z4$ (curve25519_dalek!specs.field_specs.field_square.? (I z2$))))
          (let
           ((lhs$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                (I y2$) (I x2$)
               )
              ) (I z2$)
           )))
           (let
            ((rhs$ (curve25519_dalek!specs.field_specs.field_add.? (I z4$) (I (curve25519_dalek!specs.field_specs.field_mul.?
                 (I d$) (I (curve25519_dalek!specs.field_specs.field_mul.? (I x2$) (I y2$)))
            )))))
            (= lhs$ rhs$)
    ))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? x!
      y! z!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_extended_edwards_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.)
  (forall ((x! Poly) (y! Poly) (z! Poly) (t! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? x! y! z!
      t!
     ) (and
      (and
       (not (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? z!) 0))
       (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? x! y! z!)
      )
      (= (curve25519_dalek!specs.field_specs.field_mul.? x! y!) (curve25519_dalek!specs.field_specs.field_mul.?
        z! t!
    ))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? x!
      y! z! t!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_edwards_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point!) (let
      ((x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_x.? point!)
      ))))
      (let
       ((y$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
       ))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!specs.edwards_specs.edwards_z.? point!)
        ))))
        (let
         ((t$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!specs.edwards_specs.edwards_t.? point!)
         ))))
         (curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? (I x$) (I y$)
          (I z$) (I t$)
    ))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_point_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point!) (and
      (and
       (and
        (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_x.? point!)
         ) (I 52)
        )
        (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
         ) (I 52)
       ))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         (curve25519_dalek!specs.edwards_specs.edwards_z.? point!)
        ) (I 52)
      ))
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!specs.edwards_specs.edwards_t.? point!)
       ) (I 52)
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::sum_of_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.)
  (forall ((fe1! Poly) (fe2! Poly) (bound! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? fe1! fe2! bound!) (forall
      ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 5)
         ))
         (< (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe1!)
              ))
             ) i$
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe2!)
              ))
             ) i$
           ))
          ) (%I bound!)
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe1!)
          ))
         ) i$
       ))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe2!)
          ))
         ) i$
       ))
       :qid user_curve25519_dalek__specs__field_specs__sum_of_limbs_bounded_75
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__sum_of_limbs_bounded_75
    )))
    :pattern ((curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? fe1! fe2! bound!))
    :qid internal_curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_well_formed_edwards_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? point!) (and
      (and
       (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point!)
       (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point!)
      )
      (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
       ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_x.?
         point!
        )
       ) (I 18446744073709551615)
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_identity
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_identity.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_identity.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param) (tuple%2./tuple%2
      (I 0) (I 1)
    ))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param))
     (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_add
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_add.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_add.)
  (forall ((x1! Poly) (y1! Poly) (x2! Poly) (y2! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1! x2! y2!) (let
      ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
      ))))
      (let
       ((x1x2$ (curve25519_dalek!specs.field_specs.field_mul.? x1! x2!)))
       (let
        ((y1y2$ (curve25519_dalek!specs.field_specs.field_mul.? y1! y2!)))
        (let
         ((x1y2$ (curve25519_dalek!specs.field_specs.field_mul.? x1! y2!)))
         (let
          ((y1x2$ (curve25519_dalek!specs.field_specs.field_mul.? y1! x2!)))
          (let
           ((t$ (curve25519_dalek!specs.field_specs.field_mul.? (I d$) (I (curve25519_dalek!specs.field_specs.field_mul.?
                (I x1x2$) (I y1y2$)
           )))))
           (let
            ((denom_x$ (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I t$))))
            (let
             ((denom_y$ (curve25519_dalek!specs.field_specs.field_sub.? (I 1) (I t$))))
             (let
              ((x3$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                   (I x1y2$) (I y1x2$)
                  )
                 ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I denom_x$)))
              )))
              (let
               ((y3$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                    (I y1y2$) (I x1x2$)
                   )
                  ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I denom_y$)))
               )))
               (tuple%2./tuple%2 (I x3$) (I y3$))
    )))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1! x2! y2!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_definition
))))
(assert
 (forall ((x1! Poly) (y1! Poly) (x2! Poly) (y2! Poly)) (!
   (=>
    (and
     (has_type x1! NAT)
     (has_type y1! NAT)
     (has_type x2! NAT)
     (has_type y2! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1!
       x2! y2!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1! x2! y2!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_double
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_double.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_double.)
  (forall ((x! Poly) (y! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!) (curve25519_dalek!specs.edwards_specs.edwards_add.?
      x! y! x! y!
    ))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_definition
))))
(assert
 (forall ((x! Poly) (y! Poly)) (!
   (=>
    (and
     (has_type x! NAT)
     (has_type y! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!))
     (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_scalar_mul
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.)
)
(declare-const fuel_nat%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul. Fuel)
(assert
 (forall ((point_affine! Poly) (n! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine! n!
     fuel%
    ) (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine! n!
     zero
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
     n! fuel%
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_zero_definition
)))
(assert
 (forall ((point_affine! Poly) (n! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
     (has_type n! NAT)
    )
    (= (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine! n!
      (succ fuel%)
     ) (ite
      (= (%I n!) 0)
      (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
      (ite
       (= (%I n!) 1)
       (%Poly%tuple%2. point_affine!)
       (ite
        (= (EucMod (%I n!) 2) 0)
        (let
         ((half$ (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
            (I (EucDiv (%I n!) 2)) fuel%
         )))
         (curve25519_dalek!specs.edwards_specs.edwards_double.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
            (Poly%tuple%2. half$)
           )
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. half$)))
        ))
        (let
         ((prev$ (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
            (I (nClip (Sub (%I n!) 1))) fuel%
         )))
         (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
            (Poly%tuple%2. prev$)
           )
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
           (%Poly%tuple%2. point_affine!)
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. point_affine!))
   )))))))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
     n! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.)
  (forall ((point_affine! Poly) (n! Poly)) (!
    (=>
     (and
      (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
      (has_type n! NAT)
     )
     (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine! n!) (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.?
       point_affine! n! (succ fuel_nat%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.)
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine!
      n!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_definition
))))
(assert
 (forall ((point_affine! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
     (has_type n! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?
       point_affine! n!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine!
     n!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_pre_post_definition
)))
(assert
 (forall ((point_affine! Poly) (n! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
     (has_type n! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.?
       point_affine! n! fuel%
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
     n! fuel%
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.rec__edwards_scalar_mul.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.rec__edwards_scalar_mul.?_pre_post_rec_definition
)))

;; Function-Specs curve25519_dalek::traits::Identity::identity
(declare-fun ens%curve25519_dalek!traits.Identity.identity. (Dcr Type Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (%return! Poly)) (!
   (= (ens%curve25519_dalek!traits.Identity.identity. Self%&. Self%& %return!) (has_type
     %return! Self%&
   ))
   :pattern ((ens%curve25519_dalek!traits.Identity.identity. Self%&. Self%& %return!))
   :qid internal_ens__curve25519_dalek!traits.Identity.identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!traits.Identity.identity._definition
)))

;; Function-Specs curve25519_dalek::window::LookupTable::fmt
(declare-fun ens%curve25519_dalek!window.impl&%11.fmt. (Dcr Type curve25519_dalek!window.LookupTable.
  core!fmt.Formatter. core!fmt.Formatter. core!result.Result.
 ) Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (self! curve25519_dalek!window.LookupTable.) (pre%f! core!fmt.Formatter.)
   (f! core!fmt.Formatter.) (%return! core!result.Result.)
  ) (!
   (= (ens%curve25519_dalek!window.impl&%11.fmt. T&. T& self! pre%f! f! %return!) (has_type
     (Poly%core!result.Result. %return!) (TYPE%core!result.Result. $ TYPE%tuple%0. $ TYPE%core!fmt.Error.)
   ))
   :pattern ((ens%curve25519_dalek!window.impl&%11.fmt. T&. T& self! pre%f! f! %return!))
   :qid internal_ens__curve25519_dalek!window.impl&__11.fmt._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__11.fmt._definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (VERUS_SPEC__A&. Dcr) (VERUS_SPEC__A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized VERUS_SPEC__A&.)
     (tr_bound%core!convert.From. VERUS_SPEC__A&. VERUS_SPEC__A& T&. T&)
    )
    (tr_bound%vstd!std_specs.convert.FromSpec. VERUS_SPEC__A&. VERUS_SPEC__A& T&. T&)
   )
   :pattern ((tr_bound%vstd!std_specs.convert.FromSpec. VERUS_SPEC__A&. VERUS_SPEC__A&
     T&. T&
   ))
   :qid internal_vstd__std_specs__convert__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__convert__impl&__2_trait_impl_definition
)))

;; Function-Axioms vstd::std_specs::convert::impl&%6::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%6.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%6.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 16) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%6::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%6.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%6.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 16) $ (UINT 8) v!) (I (uClip
       16 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 16) $ (UINT 8) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%7::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%7.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%7.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 32) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%7::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%7.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%7.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 32) $ (UINT 8) v!) (I (uClip
       32 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 32) $ (UINT 8) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%8::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%8.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%8.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 64) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%8::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%8.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%8.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 64) $ (UINT 8) v!) (I (uClip
       64 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 64) $ (UINT 8) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%9::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%9.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%9.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ USIZE $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%9::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%9.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%9.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ USIZE $ (UINT 8) v!) (I (uClip SZ
       (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ USIZE $ (UINT 8) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%11::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%11.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%11.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 32) $ (UINT 16)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%11::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%11.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%11.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 32) $ (UINT 16) v!) (I (uClip
       32 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 32) $ (UINT 16) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%12::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%12.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%12.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 64) $ (UINT 16)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%12::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%12.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%12.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 64) $ (UINT 16) v!) (I (uClip
       64 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 64) $ (UINT 16) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%13::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%13.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%13.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ USIZE $ (UINT 16)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%13::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%13.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%13.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ USIZE $ (UINT 16) v!) (I (uClip SZ
       (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ USIZE $ (UINT 16) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%15::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%15.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%15.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 64) $ (UINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%15::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%15.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%15.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 64) $ (UINT 32) v!) (I (uClip
       64 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 64) $ (UINT 32) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::core::iter_into_iter_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.core.iter_into_iter_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.core.iter_into_iter_spec.)
  (forall ((I&. Dcr) (I& Type) (i! Poly)) (!
    (= (vstd!std_specs.core.iter_into_iter_spec.? I&. I& i!) i!)
    :pattern ((vstd!std_specs.core.iter_into_iter_spec.? I&. I& i!))
    :qid internal_vstd!std_specs.core.iter_into_iter_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.core.iter_into_iter_spec.?_definition
))))
(assert
 (forall ((I&. Dcr) (I& Type) (i! Poly)) (!
   (=>
    (has_type i! I&)
    (has_type (vstd!std_specs.core.iter_into_iter_spec.? I&. I& i!) I&)
   )
   :pattern ((vstd!std_specs.core.iter_into_iter_spec.? I&. I& i!))
   :qid internal_vstd!std_specs.core.iter_into_iter_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.core.iter_into_iter_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::impl&%31::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ USIZE $ USIZE) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%31::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%31.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%31.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ USIZE $ USIZE self! rhs!) (B (= (uClip SZ
        (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%31::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%31.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%31.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ USIZE $ USIZE self! rhs!) (I (uClip SZ (
        Add (%I self!) (%I rhs!)
    ))))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%32::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (UINT 8) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%32::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%32.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%32.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 8) $ (UINT 8) self! rhs!) (B (= (uClip
        8 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%32::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%32.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%32.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 8) $ (UINT 8) self! rhs!) (I (uClip
       8 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%33::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%33.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%33.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (UINT 16) $ (UINT 16)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%33::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%33.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%33.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 16) $ (UINT 16) self! rhs!) (B (= (
        uClip 16 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 16) $ (UINT 16) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%33::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%33.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%33.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 16) $ (UINT 16) self! rhs!) (I (uClip
       16 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 16) $ (UINT 16) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%34::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%34.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%34.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (UINT 32) $ (UINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%34::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%34.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%34.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 32) $ (UINT 32) self! rhs!) (B (= (
        uClip 32 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 32) $ (UINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%34::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%34.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%34.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 32) $ (UINT 32) self! rhs!) (I (uClip
       32 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 32) $ (UINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%35::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (UINT 64) $ (UINT 64)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%35::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%35.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%35.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 64) $ (UINT 64) self! rhs!) (B (= (
        uClip 64 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%35::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%35.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%35.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 64) $ (UINT 64) self! rhs!) (I (uClip
       64 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%38::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%38.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%38.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (SINT 8) $ (SINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%38::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%38.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%38.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (SINT 8) $ (SINT 8) self! rhs!) (B (= (iClip
        8 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (SINT 8) $ (SINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%38::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%38.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%38.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (SINT 8) $ (SINT 8) self! rhs!) (I (iClip
       8 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (SINT 8) $ (SINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%39::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%39.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%39.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (SINT 16) $ (SINT 16)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%39::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%39.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%39.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (SINT 16) $ (SINT 16) self! rhs!) (B (= (
        iClip 16 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (SINT 16) $ (SINT 16) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%39::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%39.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%39.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (SINT 16) $ (SINT 16) self! rhs!) (I (iClip
       16 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (SINT 16) $ (SINT 16) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%40::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (SINT 32) $ (SINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%40::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%40.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%40.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (SINT 32) $ (SINT 32) self! rhs!) (B (= (
        iClip 32 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%40::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%40.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%40.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (SINT 32) $ (SINT 32) self! rhs!) (I (iClip
       32 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%3::ghost_iter
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%3.ghost_iter.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%3.ghost_iter.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? $ (TYPE%core!ops.range.Range.
        A&. A&
       ) self!
      ) (Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator
        (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. self!)) (core!ops.range.Range./Range/start
         (%Poly%core!ops.range.Range. self!)
        ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. self!))
    ))))
    :pattern ((vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? $ (TYPE%core!ops.range.Range.
       A&. A&
      ) self!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::exec_invariant
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.exec_invariant.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.exec_invariant.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (exec_iter! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.exec_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self! exec_iter!
      ) (B (and
        (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
           self!
          )
         ) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. exec_iter!))
        )
        (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
           self!
          )
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. exec_iter!))
    )))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.exec_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self! exec_iter!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.exec_invariant.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.exec_invariant.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::ghost_invariant
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.ghost_invariant.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.ghost_invariant.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (init! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self! init!
      ) (B (and
        (and
         (or
          (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
             (%Poly%vstd!std_specs.range.RangeGhostIterator. self!)
            ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
              self!
          ))))
          (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
            )
           ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
         ))))
         (or
          (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
             (%Poly%vstd!std_specs.range.RangeGhostIterator. self!)
            ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
              self!
          ))))
          (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
            )
           ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
        )))))
        (=>
         (is-core!option.Option./Some (%Poly%core!option.Option. init!))
         (let
          ((init$ (%Poly%vstd!std_specs.range.RangeGhostIterator. (core!option.Option./Some/0 (
               REF $
              ) (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&) (%Poly%core!option.Option.
               init!
          )))))
          (and
           (and
            (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
               (Poly%vstd!std_specs.range.RangeGhostIterator. init$)
              )
             ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
               (Poly%vstd!std_specs.range.RangeGhostIterator. init$)
            )))
            (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
               (Poly%vstd!std_specs.range.RangeGhostIterator. init$)
              )
             ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
               self!
           ))))
           (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
              (Poly%vstd!std_specs.range.RangeGhostIterator. init$)
             )
            ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
              self!
    ))))))))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self! init!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_invariant.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_invariant.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::ghost_ensures
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.ghost_ensures.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.ghost_ensures.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self!
      ) (B (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
           (%Poly%vstd!std_specs.range.RangeGhostIterator. self!)
          ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
            self!
    ))))))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_ensures.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_ensures.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::ghost_decrease
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.ghost_decrease.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.ghost_decrease.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.ghost_decrease.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self!
      ) (Poly%core!option.Option. (core!option.Option./Some (vstd!std_specs.range.StepSpec.spec_steps_between_int.?
         A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
           self!
          )
         ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
           self!
    )))))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_decrease.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::ghost_peek_next
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.ghost_peek_next.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.ghost_peek_next.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self!
      ) (Poly%core!option.Option. (core!option.Option./Some (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
         (%Poly%vstd!std_specs.range.RangeGhostIterator. self!)
    )))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::ghost_advance
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.ghost_advance.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.ghost_advance.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (_exec_iter! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.ghost_advance.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self! _exec_iter!
      ) (Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator
        (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
          self!
         )
        ) (core!option.Option./Some/0 A&. A& (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
           A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
            )
           ) (I 1)
         ))
        ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
          self!
    ))))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_advance.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self! _exec_iter!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_advance.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_advance.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%5::view
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%5.view.)
)
(declare-fun %%lambda%%1 (Dcr Type Poly Dcr Type) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Poly) (%%hole%%3 Dcr) (%%hole%%4
    Type
   ) (i$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4) i$)
    (core!option.Option./Some/0 %%hole%%3 %%hole%%4 (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked_int.?
       %%hole%%0 %%hole%%1 %%hole%%2 i$
   ))))
   :pattern ((%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4)
     i$
)))))
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%5.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!view.View.view.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&)
       self!
      ) (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&) (I (nClip (%I (vstd!std_specs.range.StepSpec.spec_steps_between_int.?
           A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
            )
           ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
        )))))
       ) (Poly%fun%1. (mk_fun (%%lambda%%1 A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
           (%Poly%vstd!std_specs.range.RangeGhostIterator. self!)
          ) A&. A&
    ))))))
    :pattern ((vstd!view.View.view.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&.
       A&
      ) self!
    ))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::std_specs::slice::impl&%1::spec_index_set_requires
(assert
 (fuel_bool_default fuel%vstd!std_specs.slice.impl&%1.spec_index_set_requires.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.slice.impl&%1.spec_index_set_requires.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly) (index! Poly)) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? $ (ARRAY T&. T&
        N&. N&
       ) $ USIZE self! index!
      ) (B (let
        ((tmp%%$ (%I index!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (const_int N&))
    )))))
    :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? $ (ARRAY
       T&. T& N&. N&
      ) $ USIZE self! index!
    ))
    :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_definition
    :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_definition
))))

;; Function-Axioms vstd::std_specs::slice::impl&%1::spec_index_set_ensures
(assert
 (fuel_bool_default fuel%vstd!std_specs.slice.impl&%1.spec_index_set_ensures.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.slice.impl&%1.spec_index_set_ensures.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly) (new_container! Poly)
    (index! Poly) (val! Poly)
   ) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? $ (ARRAY T&. T&
        N&. N&
       ) $ USIZE self! new_container! index! val!
      ) (B (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) new_container!) (vstd!seq.Seq.update.?
         T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!) index! val!
    )))))
    :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? $ (ARRAY
       T&. T& N&. N&
      ) $ USIZE self! new_container! index! val!
    ))
    :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_definition
    :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_definition
))))

;; Function-Axioms vstd::std_specs::slice::impl&%3::spec_index_set_requires
(assert
 (fuel_bool_default fuel%vstd!std_specs.slice.impl&%3.spec_index_set_requires.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.slice.impl&%3.spec_index_set_requires.)
  (forall ((T&. Dcr) (T& Type) (self! Poly) (index! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? $slice (SLICE
        T&. T&
       ) $ USIZE self! index!
      ) (B (let
        ((tmp%%$ (%I index!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) self!)))
    )))))
    :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? $slice
      (SLICE T&. T&) $ USIZE self! index!
    ))
    :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_definition
    :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_definition
))))

;; Function-Axioms vstd::std_specs::slice::impl&%3::spec_index_set_ensures
(assert
 (fuel_bool_default fuel%vstd!std_specs.slice.impl&%3.spec_index_set_ensures.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.slice.impl&%3.spec_index_set_ensures.)
  (forall ((T&. Dcr) (T& Type) (self! Poly) (new_container! Poly) (index! Poly) (val!
     Poly
    )
   ) (!
    (=>
     (sized T&.)
     (= (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? $slice (SLICE T&.
        T&
       ) $ USIZE self! new_container! index! val!
      ) (B (= (vstd!view.View.view.? $slice (SLICE T&. T&) new_container!) (vstd!seq.Seq.update.?
         T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) self!) index! val!
    )))))
    :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? $slice
      (SLICE T&. T&) $ USIZE self! new_container! index! val!
    ))
    :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_definition
    :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_definition
))))

;; Function-Axioms vstd::view::impl&%0::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%0.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%0.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (tr_bound%vstd!view.View. A&. A&)
     (= (vstd!view.View.view.? (REF A&.) A& self!) (vstd!view.View.view.? A&. A& self!))
    )
    :pattern ((vstd!view.View.view.? (REF A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%2::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%2.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%2.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (tr_bound%vstd!view.View. A&. A&)
     (= (vstd!view.View.view.? (BOX $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (BOX $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%4::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%4.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%4.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!view.View. A&. A&)
     )
     (= (vstd!view.View.view.? (RC $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (RC $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%6::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%6.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%6.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!view.View. A&. A&)
     )
     (= (vstd!view.View.view.? (ARC $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (ARC $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%10::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%10.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%10.view.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!view.View.view.? $ (TYPE%core!option.Option. T&. T&) self!) self!)
    )
    :pattern ((vstd!view.View.view.? $ (TYPE%core!option.Option. T&. T&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%12::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%12.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%12.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ TYPE%tuple%0. self!) self!)
    :pattern ((vstd!view.View.view.? $ TYPE%tuple%0. self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%14::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%14.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%14.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ BOOL self!) self!)
    :pattern ((vstd!view.View.view.? $ BOOL self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%16::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%16.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%16.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 8) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 8) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%18::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%18.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%18.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 16) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 16) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%20::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%20.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%20.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 32) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 32) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%22::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%22.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%22.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 64) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 64) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%26::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%26.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%26.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ USIZE self!) self!)
    :pattern ((vstd!view.View.view.? $ USIZE self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%28::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%28.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%28.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (SINT 8) self!) self!)
    :pattern ((vstd!view.View.view.? $ (SINT 8) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%30::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%30.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%30.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (SINT 16) self!) self!)
    :pattern ((vstd!view.View.view.? $ (SINT 16) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%32::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%32.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%32.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (SINT 32) self!) self!)
    :pattern ((vstd!view.View.view.? $ (SINT 32) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%40::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%40.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%40.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ CHAR self!) self!)
    :pattern ((vstd!view.View.view.? $ CHAR self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%42::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%42.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%42.view.)
  (forall ((A0&. Dcr) (A0& Type) (self! Poly)) (!
    (=>
     (and
      (sized A0&.)
      (tr_bound%vstd!view.View. A0&. A0&)
     )
     (= (vstd!view.View.view.? (DST A0&.) (TYPE%tuple%1. A0&. A0&) self!) (Poly%tuple%1.
       (tuple%1./tuple%1 (vstd!view.View.view.? A0&. A0& (tuple%1./tuple%1/0 (%Poly%tuple%1.
           self!
    )))))))
    :pattern ((vstd!view.View.view.? (DST A0&.) (TYPE%tuple%1. A0&. A0&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%44::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%44.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%44.view.)
  (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (self! Poly)) (!
    (=>
     (and
      (sized A0&.)
      (sized A1&.)
      (tr_bound%vstd!view.View. A0&. A0&)
      (tr_bound%vstd!view.View. A1&. A1&)
     )
     (= (vstd!view.View.view.? (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&) self!) (Poly%tuple%2.
       (tuple%2./tuple%2 (vstd!view.View.view.? A0&. A0& (tuple%2./tuple%2/0 (%Poly%tuple%2.
           self!
         ))
        ) (vstd!view.View.view.? A1&. A1& (tuple%2./tuple%2/1 (%Poly%tuple%2. self!)))
    ))))
    :pattern ((vstd!view.View.view.? (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%48::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%48.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%48.view.)
  (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
    (A3& Type) (self! Poly)
   ) (!
    (=>
     (and
      (sized A0&.)
      (sized A1&.)
      (sized A2&.)
      (sized A3&.)
      (tr_bound%vstd!view.View. A0&. A0&)
      (tr_bound%vstd!view.View. A1&. A1&)
      (tr_bound%vstd!view.View. A2&. A2&)
      (tr_bound%vstd!view.View. A3&. A3&)
     )
     (= (vstd!view.View.view.? (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
        A3&
       ) self!
      ) (Poly%tuple%4. (tuple%4./tuple%4 (vstd!view.View.view.? A0&. A0& (tuple%4./tuple%4/0
          (%Poly%tuple%4. self!)
         )
        ) (vstd!view.View.view.? A1&. A1& (tuple%4./tuple%4/1 (%Poly%tuple%4. self!))) (vstd!view.View.view.?
         A2&. A2& (tuple%4./tuple%4/2 (%Poly%tuple%4. self!))
        ) (vstd!view.View.view.? A3&. A3& (tuple%4./tuple%4/3 (%Poly%tuple%4. self!)))
    ))))
    :pattern ((vstd!view.View.view.? (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2&
       A3&. A3&
      ) self!
    ))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%5::obeys_add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
    (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (B true)
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%5::add_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (B (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? self! rhs! (I 18446744073709551615)))
    )
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::spec_add_fe51_limbs
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? a! b!) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
      (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Add (%I (vstd!seq.Seq.index.?
              $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
                (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                  a!
               )))
              ) (I 0)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 0)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 1)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 1)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 2)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 2)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 3)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 3)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 4)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 4)
    ))))))))))
    :pattern ((curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type b! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?
       a! b!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%5::add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?
       self! rhs!
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::projective_niels_point_as_affine_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.)
  (forall ((niels! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
      niels!
     ) (let
      ((y_plus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
           (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
      )))))
      (let
       ((y_minus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
            (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
       )))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
             (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
        )))))
        (let
         ((x_proj$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
              (I y_plus_x$) (I y_minus_x$)
             )
            ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
         )))
         (let
          ((y_proj$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
               (I y_plus_x$) (I y_minus_x$)
              )
             ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
          )))
          (let
           ((z_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I z$))))
           (let
            ((x$ (curve25519_dalek!specs.field_specs.field_mul.? (I x_proj$) (I z_inv$))))
            (let
             ((y$ (curve25519_dalek!specs.field_specs.field_mul.? (I y_proj$) (I z_inv$))))
             (tuple%2./tuple%2 (I x$) (I y$))
    )))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
      niels!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_definition
))))
(assert
 (forall ((niels! Poly)) (!
   (=>
    (has_type niels! TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
       niels!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
     niels!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::projective_niels_corresponds_to_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.)
  (forall ((niels! Poly) (point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
      niels! point!
     ) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((t$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (let
           ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
           ))))
           (let
            ((y_plus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
                 (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
            )))))
            (let
             ((y_minus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
                  (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
             )))))
             (let
              ((niels_z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                  (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
                   (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
              )))))
              (let
               ((t2d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                   (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
                    (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
               )))))
               (and
                (and
                 (and
                  (= y_plus_x$ (curve25519_dalek!specs.field_specs.field_add.? (I y$) (I x$)))
                  (= y_minus_x$ (curve25519_dalek!specs.field_specs.field_sub.? (I y$) (I x$)))
                 )
                 (= niels_z$ z$)
                )
                (= t2d$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                    (I 2) (I d$)
                   )
                  ) (I t$)
    ))))))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
      niels! point!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_projective_niels_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.)
  (forall ((niels! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? niels!)
     (exists ((point$ Poly)) (!
       (and
        (has_type point$ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
        (and
         (and
          (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point$)
          (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point$)
         )
         (curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.? niels!
          point$
       )))
       :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
         niels! point$
       ))
       :qid user_curve25519_dalek__specs__edwards_specs__is_valid_projective_niels_point_76
       :skolemid skolem_user_curve25519_dalek__specs__edwards_specs__is_valid_projective_niels_point_76
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? niels!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::is_valid_naf_lookup_table5_projective
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.)
  (forall ((table! Poly) (A! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.? table!
      A!
     ) (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
           (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
            (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              $ (CONST_INT 8)
             ) table!
            ) j$
           )
          ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
             A!
            )
           ) (I (nClip (Add (Mul 2 (%I j$)) 1)))
       ))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 8)
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__is_valid_naf_lookup_table5_projective_77
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__is_valid_naf_lookup_table5_projective_77
    )))
    :pattern ((curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.?
      table! A!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::naf_lookup_table5_projective_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.)
  (forall ((table! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?
      table!
     ) (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (let
          ((entry$ (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (
              vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                $ (CONST_INT 8)
               ) table!
              ) j$
          ))))
          (and
           (and
            (and
             (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
                (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                  entry$
               )))
              ) (I 54)
             )
             (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
                (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                  entry$
               )))
              ) (I 54)
            ))
            (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
               (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                 entry$
              )))
             ) (I 54)
           ))
           (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
              (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                entry$
             )))
            ) (I 54)
       )))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 8)
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__naf_lookup_table5_projective_limbs_bounded_78
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__naf_lookup_table5_projective_limbs_bounded_78
    )))
    :pattern ((curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?
      table!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::is_valid_lookup_table_projective
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.)
  (forall ((N&. Dcr) (N& Type) (table! Poly) (P! Poly) (size! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.? N&. N& table!
      P! size!
     ) (and
      (= (vstd!slice.spec_slice_len.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
        (vstd!array.spec_array_as_slice.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         N&. N& table!
        )
       ) (%I size!)
      )
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (%I size!))
          ))
          (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
            (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
               N&. N&
              ) table!
             ) j$
            )
           ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
              P!
             )
            ) (I (nClip (Add (%I j$) 1)))
        ))))
        :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
            N&. N&
           ) table!
          ) j$
        ))
        :qid user_curve25519_dalek__specs__window_specs__is_valid_lookup_table_projective_79
        :skolemid skolem_user_curve25519_dalek__specs__window_specs__is_valid_lookup_table_projective_79
    ))))
    :pattern ((curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.? N&.
      N& table! P! size!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::lookup_table_projective_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.)
  (forall ((N&. Dcr) (N& Type) (table! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.? N&.
      N& table!
     ) (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (vstd!slice.spec_slice_len.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             (vstd!array.spec_array_as_slice.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              N&. N& table!
         )))))
         (let
          ((entry$ (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (
              vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                N&. N&
               ) table!
              ) j$
          ))))
          (and
           (and
            (and
             (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
                (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                  entry$
               )))
              ) (I 54)
             )
             (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
                (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                  entry$
               )))
              ) (I 54)
            ))
            (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
               (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                 entry$
              )))
             ) (I 54)
           ))
           (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
              (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                entry$
             )))
            ) (I 54)
       )))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           N&. N&
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__lookup_table_projective_limbs_bounded_80
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__lookup_table_projective_limbs_bounded_80
    )))
    :pattern ((curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.?
      N&. N& table!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%28::obeys_add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
    (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%28::add_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. self!
      rhs!
     ) (B (and
       (and
        (and
         (and
          (and
           (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? self!)
           (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
              (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. rhs!)
             )
            ) (I 54)
          ))
          (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
             (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. rhs!)
            )
           ) (I 54)
         ))
         (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
            (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. rhs!)
           )
          ) (I 54)
        ))
        (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
           (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. rhs!)
          )
         ) (I 54)
       ))
       (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? rhs!)
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. self!
      rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%28::add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. self!
      rhs!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    )
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. self!
      rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%32::obeys_add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
    (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_z_sum_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.? point!) (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.?
      (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_z.?
        point!
       )
      ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_z.?
        point!
       )
      ) (I 18446744073709551615)
    ))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::affine_niels_corresponds_to_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.)
  (forall ((niels! Poly) (point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.? niels!
      point!
     ) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!)))
      (let
       ((x_proj$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y_proj$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z_proj$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((_t$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (let
           ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
           ))))
           (let
            ((z_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I z_proj$))))
            (let
             ((x$ (curve25519_dalek!specs.field_specs.field_mul.? (I x_proj$) (I z_inv$))))
             (let
              ((y$ (curve25519_dalek!specs.field_specs.field_mul.? (I y_proj$) (I z_inv$))))
              (let
               ((y_plus_x_niels$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                   (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
                    (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!)
               )))))
               (let
                ((y_minus_x_niels$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                    (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
                     (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!)
                )))))
                (let
                 ((xy2d_niels$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                     (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
                      (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!)
                 )))))
                 (and
                  (and
                   (= y_plus_x_niels$ (curve25519_dalek!specs.field_specs.field_add.? (I y$) (I x$)))
                   (= y_minus_x_niels$ (curve25519_dalek!specs.field_specs.field_sub.? (I y$) (I x$)))
                  )
                  (= xy2d_niels$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                      (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I y$))) (I 2)
                     )
                    ) (I d$)
    ))))))))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.?
      niels! point!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_affine_niels_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.)
  (forall ((niels! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? niels!) (exists
      ((point$ Poly)) (!
       (and
        (has_type point$ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
        (and
         (and
          (and
           (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point$)
           (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point$)
          )
          (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!specs.edwards_specs.edwards_y.? point$)
           ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_x.?
             point$
            )
           ) (I 18446744073709551615)
         ))
         (curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.? niels!
          point$
       )))
       :pattern ((curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.?
         niels! point$
       ))
       :qid user_curve25519_dalek__specs__edwards_specs__is_valid_affine_niels_point_81
       :skolemid skolem_user_curve25519_dalek__specs__edwards_specs__is_valid_affine_niels_point_81
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? niels!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%32::add_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. self!
      rhs!
     ) (B (and
       (and
        (and
         (and
          (and
           (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? self!)
           (curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.? self!)
          )
          (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
             (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. rhs!)
            )
           ) (I 54)
         ))
         (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
            (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. rhs!)
           )
          ) (I 54)
        ))
        (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
           (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. rhs!)
          )
         ) (I 54)
       ))
       (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? rhs!)
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. self!
      rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%32::add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. self!
      rhs!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    )
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. self!
      rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::affine_niels_point_as_affine_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.)
  (forall ((niels! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.? niels!)
     (let
      ((y_plus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
           (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!)
      )))))
      (let
       ((y_minus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
            (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!)
       )))))
       (let
        ((x$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
             (I y_plus_x$) (I y_minus_x$)
            )
           ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
        )))
        (let
         ((y$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
              (I y_plus_x$) (I y_minus_x$)
             )
            ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
         )))
         (tuple%2./tuple%2 (I x$) (I y$))
    )))))
    :pattern ((curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?
      niels!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?_definition
))))
(assert
 (forall ((niels! Poly)) (!
   (=>
    (has_type niels! TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?
       niels!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?
     niels!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::window_specs::is_valid_lookup_table_affine_coords
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.)
  (forall ((N&. Dcr) (N& Type) (table! Poly) (basepoint! Poly) (size! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.? N&. N&
      table! basepoint! size!
     ) (and
      (= (vstd!slice.spec_slice_len.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
        (vstd!array.spec_array_as_slice.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
         N&. N& table!
        )
       ) (%I size!)
      )
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (%I size!))
          ))
          (= (curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.? (vstd!seq.Seq.index.?
             $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
              $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. N&.
               N&
              ) table!
             ) j$
            )
           ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? basepoint! (I (nClip (Add
               (%I j$) 1
        )))))))
        :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
          (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
            N&. N&
           ) table!
          ) j$
        ))
        :qid user_curve25519_dalek__specs__window_specs__is_valid_lookup_table_affine_coords_82
        :skolemid skolem_user_curve25519_dalek__specs__window_specs__is_valid_lookup_table_affine_coords_82
    ))))
    :pattern ((curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.?
      N&. N& table! basepoint! size!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::lookup_table_affine_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.)
  (forall ((N&. Dcr) (N& Type) (table! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.? N&. N&
      table!
     ) (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (vstd!slice.spec_slice_len.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
             (vstd!array.spec_array_as_slice.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
              N&. N& table!
         )))))
         (let
          ((entry$ (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!seq.Seq.index.?
              $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
               $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. N&.
                N&
               ) table!
              ) j$
          ))))
          (and
           (and
            (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
               (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
                 entry$
              )))
             ) (I 54)
            )
            (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
               (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
                 entry$
              )))
             ) (I 54)
           ))
           (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
              (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
                entry$
             )))
            ) (I 54)
       )))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           N&. N&
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__lookup_table_affine_limbs_bounded_83
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__lookup_table_affine_limbs_bounded_83
    )))
    :pattern ((curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.?
      N&. N& table!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_on_edwards_curve
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.)
  (forall ((x! Poly) (y! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? x! y!) (let
      ((p$ (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
      (let
       ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
       ))))
       (let
        ((x2$ (curve25519_dalek!specs.field_specs.field_square.? x!)))
        (let
         ((y2$ (curve25519_dalek!specs.field_specs.field_square.? y!)))
         (let
          ((x2y2$ (curve25519_dalek!specs.field_specs.field_mul.? (I x2$) (I y2$))))
          (let
           ((lhs$ (curve25519_dalek!specs.field_specs.field_sub.? (I y2$) (I x2$))))
           (let
            ((rhs$ (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I (curve25519_dalek!specs.field_specs.field_mul.?
                 (I d$) (I x2y2$)
            )))))
            (= lhs$ rhs$)
    ))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? x! y!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_identity_edwards_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.? point!) (let
      ((x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_x.? point!)
      ))))
      (let
       ((y$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
       ))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!specs.edwards_specs.edwards_z.? point!)
        ))))
        (and
         (and
          (not (= z$ 0))
          (= x$ 0)
         )
         (= y$ z$)
    )))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::completed_point_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_nat.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.completed_point_as_nat.? point!) (let
      ((x_abs$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
            point!
      ))))))
      (let
       ((y_abs$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
             point!
       ))))))
       (let
        ((z_abs$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
              point!
        ))))))
        (let
         ((t_abs$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
               point!
         ))))))
         (tuple%4./tuple%4 (I x_abs$) (I y_abs$) (I z_abs$) (I t_abs$))
    )))))
    :pattern ((curve25519_dalek!specs.edwards_specs.completed_point_as_nat.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.completed_point_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.completed_point_as_nat.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (has_type (Poly%tuple%4. (curve25519_dalek!specs.edwards_specs.completed_point_as_nat.?
       point!
      )
     ) (TYPE%tuple%4. $ NAT $ NAT $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.completed_point_as_nat.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.completed_point_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.completed_point_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::completed_point_as_affine_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.? point!)
     (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.completed_point_as_nat.? point!)))
      (let
       ((x_abs$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y_abs$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z_abs$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((t_abs$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (let
           ((z_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I z_abs$))))
           (let
            ((t_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I t_abs$))))
            (tuple%2./tuple%2 (I (curve25519_dalek!specs.field_specs.field_mul.? (I x_abs$) (I z_inv$)))
             (I (curve25519_dalek!specs.field_specs.field_mul.? (I y_abs$) (I t_inv$)))
    )))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?
      point!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?
       point!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?
     point!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::identity_affine_niels
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.identity_affine_niels.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.identity_affine_niels.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.identity_affine_niels.? no%param) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint
      (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 0) (I 0) (I 0) (I 0) (I 0)))
    ))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.identity_affine_niels.? no%param))
    :qid internal_curve25519_dalek!specs.edwards_specs.identity_affine_niels.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_affine_niels.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (curve25519_dalek!specs.edwards_specs.identity_affine_niels.?
       no%param
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.identity_affine_niels.? no%param))
   :qid internal_curve25519_dalek!specs.edwards_specs.identity_affine_niels.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_affine_niels.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::identity_projective_niels
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.identity_projective_niels.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.identity_projective_niels.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? no%param) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
      (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 0) (I 0) (I 0) (I 0) (I 0)))
    ))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.identity_projective_niels.? no%param))
    :qid internal_curve25519_dalek!specs.edwards_specs.identity_projective_niels.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_projective_niels.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? no%param)
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.identity_projective_niels.? no%param))
   :qid internal_curve25519_dalek!specs.edwards_specs.identity_projective_niels.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_projective_niels.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_completed_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_completed_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_completed_point.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? point!) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.completed_point_as_nat.? point!)))
      (let
       ((x_abs$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y_abs$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z_abs$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((t_abs$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (and
           (and
            (not (= z_abs$ 0))
            (not (= t_abs$ 0))
           )
           (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I (curve25519_dalek!specs.field_specs.field_mul.?
              (I x_abs$) (I (curve25519_dalek!specs.field_specs.field_inv.? (I z_abs$)))
             )
            ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I y_abs$) (I (curve25519_dalek!specs.field_specs.field_inv.?
                (I t_abs$)
    ))))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_completed_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_completed_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::completed_to_extended
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.completed_to_extended.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.completed_to_extended.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.completed_to_extended.? point!) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.completed_point_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((t$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (tuple%4./tuple%4 (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I t$)))
           (I (curve25519_dalek!specs.field_specs.field_mul.? (I y$) (I z$))) (I (curve25519_dalek!specs.field_specs.field_mul.?
             (I z$) (I t$)
            )
           ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I y$)))
    )))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.completed_to_extended.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.completed_to_extended.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.completed_to_extended.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (has_type (Poly%tuple%4. (curve25519_dalek!specs.edwards_specs.completed_to_extended.?
       point!
      )
     ) (TYPE%tuple%4. $ NAT $ NAT $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.completed_to_extended.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.completed_to_extended.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.completed_to_extended.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_as_nat.)
  (forall ((fe! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
      (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
    ))))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_definition
))))
(assert
 (forall ((fe! Poly)) (!
   (=>
    (has_type fe! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (<= 0 (curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!))
   :qid internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::window_specs::is_valid_lookup_table_affine
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.)
  (forall ((N&. Dcr) (N& Type) (table! Poly) (P! Poly) (size! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.? N&. N& table!
      P! size!
     ) (curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.? N&. N&
      table! (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
        P!
       )
      ) size!
    ))
    :pattern ((curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.? N&. N&
      table! P! size!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::naf_lookup_table5_affine_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.)
  (forall ((table! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.? table!)
     (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (let
          ((entry$ (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!seq.Seq.index.?
              $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
               $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. $ (
                 CONST_INT 8
                )
               ) table!
              ) j$
          ))))
          (and
           (and
            (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
               (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
                 entry$
              )))
             ) (I 54)
            )
            (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
               (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
                 entry$
              )))
             ) (I 54)
           ))
           (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
              (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
                entry$
             )))
            ) (I 54)
       )))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           $ (CONST_INT 8)
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__naf_lookup_table5_affine_limbs_bounded_84
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__naf_lookup_table5_affine_limbs_bounded_84
    )))
    :pattern ((curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.?
      table!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::is_valid_naf_lookup_table5_affine
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.)
  (forall ((table! Poly) (A! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.? table!
      A!
     ) (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (= (curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.? (vstd!seq.Seq.index.?
            $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
             $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. $ (
               CONST_INT 8
              )
             ) table!
            ) j$
           )
          ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
             A!
            )
           ) (I (nClip (Add (Mul 2 (%I j$)) 1)))
       ))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           $ (CONST_INT 8)
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__is_valid_naf_lookup_table5_affine_85
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__is_valid_naf_lookup_table5_affine_85
    )))
    :pattern ((curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.?
      table! A!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::naf_lookup_table8_projective_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.naf_lookup_table8_projective_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.naf_lookup_table8_projective_limbs_bounded.)
  (forall ((table! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.naf_lookup_table8_projective_limbs_bounded.?
      table!
     ) (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 64)
         ))
         (let
          ((entry$ (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (
              vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                $ (CONST_INT 64)
               ) table!
              ) j$
          ))))
          (and
           (and
            (and
             (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
                (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                  entry$
               )))
              ) (I 54)
             )
             (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
                (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                  entry$
               )))
              ) (I 54)
            ))
            (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
               (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                 entry$
              )))
             ) (I 54)
           ))
           (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
              (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                entry$
             )))
            ) (I 54)
       )))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 64)
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__naf_lookup_table8_projective_limbs_bounded_86
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__naf_lookup_table8_projective_limbs_bounded_86
    )))
    :pattern ((curve25519_dalek!specs.window_specs.naf_lookup_table8_projective_limbs_bounded.?
      table!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.naf_lookup_table8_projective_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.naf_lookup_table8_projective_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::naf_lookup_table8_affine_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.naf_lookup_table8_affine_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.naf_lookup_table8_affine_limbs_bounded.)
  (forall ((table! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.naf_lookup_table8_affine_limbs_bounded.? table!)
     (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 64)
         ))
         (let
          ((entry$ (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!seq.Seq.index.?
              $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
               $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. $ (
                 CONST_INT 64
                )
               ) table!
              ) j$
          ))))
          (and
           (and
            (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
               (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
                 entry$
              )))
             ) (I 54)
            )
            (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
               (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
                 entry$
              )))
             ) (I 54)
           ))
           (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
              (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
                entry$
             )))
            ) (I 54)
       )))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           $ (CONST_INT 64)
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__naf_lookup_table8_affine_limbs_bounded_87
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__naf_lookup_table8_affine_limbs_bounded_87
    )))
    :pattern ((curve25519_dalek!specs.window_specs.naf_lookup_table8_affine_limbs_bounded.?
      table!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.naf_lookup_table8_affine_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.naf_lookup_table8_affine_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::is_valid_naf_lookup_table8_projective
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_projective.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_projective.)
  (forall ((table! Poly) (A! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_projective.? table!
      A!
     ) (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 64)
         ))
         (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
           (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
            (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              $ (CONST_INT 64)
             ) table!
            ) j$
           )
          ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
             A!
            )
           ) (I (nClip (Add (Mul 2 (%I j$)) 1)))
       ))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 64)
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__is_valid_naf_lookup_table8_projective_88
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__is_valid_naf_lookup_table8_projective_88
    )))
    :pattern ((curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_projective.?
      table! A!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_projective.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_projective.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::is_valid_naf_lookup_table8_affine
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_affine.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_affine.)
  (forall ((table! Poly) (A! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_affine.? table!
      A!
     ) (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 64)
         ))
         (= (curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.? (vstd!seq.Seq.index.?
            $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
             $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. $ (
               CONST_INT 64
              )
             ) table!
            ) j$
           )
          ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
             A!
            )
           ) (I (nClip (Add (Mul 2 (%I j$)) 1)))
       ))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           $ (CONST_INT 64)
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__is_valid_naf_lookup_table8_affine_89
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__is_valid_naf_lookup_table8_affine_89
    )))
    :pattern ((curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_affine.?
      table! A!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_affine.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_affine.?_definition
))))

;; Function-Axioms curve25519_dalek::window::LookupTable::obeys_from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%0.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%0.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (TYPE%curve25519_dalek!window.LookupTable.
     $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
    ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::window::LookupTable::from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%0.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%0.from_spec.)
  (forall ((P! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. P!
     ) (vstd!pervasive.arbitrary.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
    )
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. P!
    ))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::window::LookupTable::obeys_from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%1.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%1.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (TYPE%curve25519_dalek!window.LookupTable.
     $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
    ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::window::LookupTable::from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%1.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%1.from_spec.)
  (forall ((P! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. P!
     ) (vstd!pervasive.arbitrary.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
    )
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. P!
    ))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::window::NafLookupTable5::obeys_from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%2.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%2.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable5.
     $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
    ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::window::NafLookupTable5::from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%2.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%2.from_spec.)
  (forall ((A! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable5.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A!
     ) (vstd!pervasive.arbitrary.? $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
    )
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable5.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A!
    ))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::window::NafLookupTable5::obeys_from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%3.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%3.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable5.
     $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
    ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::window::NafLookupTable5::from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%3.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%3.from_spec.)
  (forall ((A! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable5.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A!
     ) (vstd!pervasive.arbitrary.? $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
    )
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable5.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A!
    ))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::window::NafLookupTable8::obeys_from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%4.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%4.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable8.
     $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
    ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::window::NafLookupTable8::from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%4.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%4.from_spec.)
  (forall ((A! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable8.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A!
     ) (vstd!pervasive.arbitrary.? $ (TYPE%curve25519_dalek!window.NafLookupTable8. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
    )
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable8.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A!
    ))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::window::NafLookupTable8::obeys_from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%5.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%5.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable8.
     $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
    ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::window::NafLookupTable8::from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%5.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%5.from_spec.)
  (forall ((A! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable8.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A!
     ) (vstd!pervasive.arbitrary.? $ (TYPE%curve25519_dalek!window.NafLookupTable8. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
    )
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable8.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A!
    ))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::edwards::EdwardsPoint::well_formed
(assert
 (fuel_bool_default fuel%curve25519_dalek!edwards.impl&%15.well_formed.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!edwards.impl&%15.well_formed.)
  (forall ((self! Poly)) (!
    (= (curve25519_dalek!edwards.impl&%15.well_formed.? self!) (and
      (and
       (and
        (and
         (and
          (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X (%Poly%curve25519_dalek!edwards.EdwardsPoint.
              self!
            ))
           ) (I 52)
          )
          (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y (%Poly%curve25519_dalek!edwards.EdwardsPoint.
              self!
            ))
           ) (I 52)
         ))
         (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z (%Poly%curve25519_dalek!edwards.EdwardsPoint.
             self!
           ))
          ) (I 52)
        ))
        (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T (%Poly%curve25519_dalek!edwards.EdwardsPoint.
            self!
          ))
         ) (I 52)
       ))
       (curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
          (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X
            (%Poly%curve25519_dalek!edwards.EdwardsPoint. self!)
         )))
        ) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y (%Poly%curve25519_dalek!edwards.EdwardsPoint.
             self!
         ))))
        ) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z (%Poly%curve25519_dalek!edwards.EdwardsPoint.
             self!
         ))))
        ) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T (%Poly%curve25519_dalek!edwards.EdwardsPoint.
             self!
      )))))))
      (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y (%Poly%curve25519_dalek!edwards.EdwardsPoint.
          self!
        ))
       ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X
         (%Poly%curve25519_dalek!edwards.EdwardsPoint. self!)
        )
       ) (I 18446744073709551615)
    )))
    :pattern ((curve25519_dalek!edwards.impl&%15.well_formed.? self!))
    :qid internal_curve25519_dalek!edwards.impl&__15.well_formed.?_definition
    :skolemid skolem_internal_curve25519_dalek!edwards.impl&__15.well_formed.?_definition
))))

;; Function-Axioms curve25519_dalek::edwards::impl&%31::obeys_add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!edwards.impl&%31.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!edwards.impl&%31.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
    (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::edwards::impl&%31::add_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!edwards.impl&%31.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!edwards.impl&%31.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. self! rhs!
     ) (B (and
       (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? self!)
       (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? rhs!)
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms curve25519_dalek::edwards::impl&%31::add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!edwards.impl&%31.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!edwards.impl&%31.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. self! rhs!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    )
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%vstd!view.View. A&. A&)
    (tr_bound%vstd!view.View. (REF A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (REF A&.) A&))
   :qid internal_vstd__view__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%vstd!view.View. A&. A&)
    (tr_bound%vstd!view.View. (BOX $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!view.View. A&. A&)
    )
    (tr_bound%vstd!view.View. (RC $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__4_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!view.View. A&. A&)
    )
    (tr_bound%vstd!view.View. (ARC $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__6_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!view.View. $ (TYPE%core!option.Option. T&. T&))
   )
   :pattern ((tr_bound%vstd!view.View. $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_vstd__view__impl&__10_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__10_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (SINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type)) (!
   (=>
    (and
     (sized A0&.)
     (tr_bound%vstd!view.View. A0&. A0&)
    )
    (tr_bound%vstd!view.View. (DST A0&.) (TYPE%tuple%1. A0&. A0&))
   )
   :pattern ((tr_bound%vstd!view.View. (DST A0&.) (TYPE%tuple%1. A0&. A0&)))
   :qid internal_vstd__view__impl&__42_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__42_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (=>
    (and
     (sized A0&.)
     (sized A1&.)
     (tr_bound%vstd!view.View. A0&. A0&)
     (tr_bound%vstd!view.View. A1&. A1&)
    )
    (tr_bound%vstd!view.View. (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&))
   )
   :pattern ((tr_bound%vstd!view.View. (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_vstd__view__impl&__44_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__44_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
   (A3& Type)
  ) (!
   (=>
    (and
     (sized A0&.)
     (sized A1&.)
     (sized A2&.)
     (sized A3&.)
     (tr_bound%vstd!view.View. A0&. A0&)
     (tr_bound%vstd!view.View. A1&. A1&)
     (tr_bound%vstd!view.View. A2&. A2&)
     (tr_bound%vstd!view.View. A3&. A3&)
    )
    (tr_bound%vstd!view.View. (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
      A3&
   )))
   :pattern ((tr_bound%vstd!view.View. (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&.
      A2& A3&. A3&
   )))
   :qid internal_vstd__view__impl&__48_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__48_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ BOOL $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 16) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 16) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 32) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 32) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 64) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 64) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ USIZE $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ USIZE $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 32) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 32) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 64) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 64) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ USIZE $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ USIZE $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 64) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 64) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 16) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (UINT 16) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (SINT 8) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (SINT 8) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (SINT 16) $ (SINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (SINT 16) $ (SINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (SINT 8) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (SINT 8) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 16) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 16) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (SINT 16) $ (SINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (SINT 16) $ (SINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.PartialEq. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialEq. $ (TYPE%core!option.Option. T&. T&) $ (TYPE%core!option.Option.
      T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (TYPE%core!option.Option. T&. T&) $ (TYPE%core!option.Option.
      T&. T&
   )))
   :qid internal_core__option__impl&__15_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__15_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. $ (TYPE%core!option.Option. T&. T&) $ (TYPE%core!option.Option.
      T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialOrd. $ (TYPE%core!option.Option. T&. T&) $ (TYPE%core!option.Option.
      T&. T&
   )))
   :qid internal_core__option__impl&__16_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__16_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
    )
    (tr_bound%vstd!pervasive.ForLoopGhostIteratorNew. $ (TYPE%core!ops.range.Range. A&.
      A&
   )))
   :pattern ((tr_bound%vstd!pervasive.ForLoopGhostIteratorNew. $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_vstd__std_specs__range__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__range__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
     (tr_bound%core!iter.range.Step. A&. A&)
    )
    (tr_bound%vstd!pervasive.ForLoopGhostIterator. $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :pattern ((tr_bound%vstd!pervasive.ForLoopGhostIterator. $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_vstd__std_specs__range__impl&__4_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__range__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
     (tr_bound%core!iter.range.Step. A&. A&)
    )
    (tr_bound%vstd!view.View. $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
   )
   :pattern ((tr_bound%vstd!view.View. $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_vstd__std_specs__range__impl&__5_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__range__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!std_specs.core.TrustedSpecSealed. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%vstd!std_specs.core.TrustedSpecSealed. $ (ARRAY T&. T& N&. N&)))
   :qid internal_vstd__std_specs__slice__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__slice__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized I&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!ops.index.Index. $slice (SLICE T&. T&) I&. I&)
    )
    (tr_bound%core!ops.index.Index. $ (ARRAY T&. T& N&. N&) I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.Index. $ (ARRAY T&. T& N&. N&) I&. I&))
   :qid internal_core__array__impl&__15_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__15_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized I&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!ops.index.IndexMut. $slice (SLICE T&. T&) I&. I&)
    )
    (tr_bound%core!ops.index.IndexMut. $ (ARRAY T&. T& N&. N&) I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.IndexMut. $ (ARRAY T&. T& N&. N&) I&. I&))
   :qid internal_core__array__impl&__16_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__16_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized I&.)
     (tr_bound%core!slice.index.SliceIndex. I&. I& $slice (SLICE T&. T&))
    )
    (tr_bound%core!ops.index.Index. $slice (SLICE T&. T&) I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.Index. $slice (SLICE T&. T&) I&. I&))
   :qid internal_core__slice__index__impl&__0_trait_impl_definition
   :skolemid skolem_internal_core__slice__index__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized I&.)
     (tr_bound%core!slice.index.SliceIndex. I&. I& $slice (SLICE T&. T&))
    )
    (tr_bound%core!ops.index.IndexMut. $slice (SLICE T&. T&) I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.IndexMut. $slice (SLICE T&. T&) I&. I&))
   :qid internal_core__slice__index__impl&__1_trait_impl_definition
   :skolemid skolem_internal_core__slice__index__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!slice.index.SliceIndex. $ USIZE $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%core!slice.index.SliceIndex. $ USIZE $slice (SLICE T&. T&)))
   :qid internal_core__slice__index__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__slice__index__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. $ (ARRAY T&. T& N&. N&) $ USIZE)
   )
   :pattern ((tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. $ (ARRAY T&. T& N&. N&)
     $ USIZE
   ))
   :qid internal_vstd__std_specs__slice__impl&__1_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__slice__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!std_specs.core.TrustedSpecSealed. $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%vstd!std_specs.core.TrustedSpecSealed. $slice (SLICE T&. T&)))
   :qid internal_vstd__std_specs__slice__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__slice__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. $slice (SLICE T&. T&) $ USIZE)
   )
   :pattern ((tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. $slice (SLICE T&. T&)
     $ USIZE
   ))
   :qid internal_vstd__std_specs__slice__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__slice__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (SINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!clone.Clone. (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%core!clone.Clone. (CONST_PTR $) (PTR T&. T&)))
   :qid internal_core__clone__impls__impl&__1_trait_impl_definition
   :skolemid skolem_internal_core__clone__impls__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!clone.Clone. $ (PTR T&. T&))
   :pattern ((tr_bound%core!clone.Clone. $ (PTR T&. T&)))
   :qid internal_core__clone__impls__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__clone__impls__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!clone.Clone. (REF T&.) T&)
   :pattern ((tr_bound%core!clone.Clone. (REF T&.) T&))
   :qid internal_core__clone__impls__impl&__3_trait_impl_definition
   :skolemid skolem_internal_core__clone__impls__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((Idx&. Dcr) (Idx& Type)) (!
   (=>
    (and
     (sized Idx&.)
     (tr_bound%core!clone.Clone. Idx&. Idx&)
    )
    (tr_bound%core!clone.Clone. $ (TYPE%core!ops.range.Range. Idx&. Idx&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (TYPE%core!ops.range.Range. Idx&. Idx&)))
   :qid internal_core__ops__range__impl&__46_trait_impl_definition
   :skolemid skolem_internal_core__ops__range__impl&__46_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!clone.Clone. T&. T&)
    )
    (tr_bound%core!clone.Clone. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (ARRAY T&. T& N&. N&)))
   :qid internal_core__array__impl&__20_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__20_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized E&.)
     (tr_bound%core!clone.Clone. T&. T&)
     (tr_bound%core!clone.Clone. E&. E&)
    )
    (tr_bound%core!clone.Clone. $ (TYPE%core!result.Result. T&. T& E&. E&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (TYPE%core!result.Result. T&. T& E&. E&)))
   :qid internal_core__result__impl&__5_trait_impl_definition
   :skolemid skolem_internal_core__result__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ ALLOCATOR_GLOBAL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $slice STRSLICE $slice STRSLICE)
)

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type) (B&. Dcr) (B& Type)) (!
   (=>
    (tr_bound%core!cmp.PartialEq. A&. A& B&. B&)
    (tr_bound%core!cmp.PartialEq. (REF A&.) A& (REF B&.) B&)
   )
   :pattern ((tr_bound%core!cmp.PartialEq. (REF A&.) A& (REF B&.) B&))
   :qid internal_core__cmp__impls__impl&__9_trait_impl_definition
   :skolemid skolem_internal_core__cmp__impls__impl&__9_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. (REF $slice) (SLICE T&. T&) $ (ARRAY U&. U& N&. N&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. (REF $slice) (SLICE T&. T&) $ (ARRAY U&. U&
      N&. N&
   )))
   :qid internal_core__array__equality__impl&__4_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.PartialEq. (CONST_PTR $) (PTR T&. T&) (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.PartialEq. (CONST_PTR $) (PTR T&. T&) (CONST_PTR $) (PTR
      T&. T&
   )))
   :qid internal_core__ptr__const_ptr__impl&__6_trait_impl_definition
   :skolemid skolem_internal_core__ptr__const_ptr__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.PartialEq. $ (PTR T&. T&) $ (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (PTR T&. T&) $ (PTR T&. T&)))
   :qid internal_core__ptr__mut_ptr__impl&__6_trait_impl_definition
   :skolemid skolem_internal_core__ptr__mut_ptr__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ TYPE%tuple%0. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ CHAR $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (forall ((Idx&. Dcr) (Idx& Type)) (!
   (=>
    (and
     (sized Idx&.)
     (tr_bound%core!cmp.PartialEq. Idx&. Idx& Idx&. Idx&)
    )
    (tr_bound%core!cmp.PartialEq. $ (TYPE%core!ops.range.Range. Idx&. Idx&) $ (TYPE%core!ops.range.Range.
      Idx&. Idx&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (TYPE%core!ops.range.Range. Idx&. Idx&) $
     (TYPE%core!ops.range.Range. Idx&. Idx&)
   ))
   :qid internal_core__ops__range__impl&__49_trait_impl_definition
   :skolemid skolem_internal_core__ops__range__impl&__49_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) $ (ARRAY U&. U& N&. N&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) $ (ARRAY U&. U& N&.
      N&
   )))
   :qid internal_core__array__equality__impl&__0_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) $slice (SLICE U&. U&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) $slice (SLICE U&. U&)))
   :qid internal_core__array__equality__impl&__1_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) (REF $slice) (SLICE U&. U&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) (REF $slice) (SLICE
      U&. U&
   )))
   :qid internal_core__array__equality__impl&__3_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $slice (SLICE T&. T&) $ (ARRAY U&. U& N&. N&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. $slice (SLICE T&. T&) $ (ARRAY U&. U& N&. N&)))
   :qid internal_core__array__equality__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $slice (SLICE T&. T&) $slice (SLICE U&. U&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. $slice (SLICE T&. T&) $slice (SLICE U&. U&)))
   :qid internal_core__slice__cmp__impl&__0_trait_impl_definition
   :skolemid skolem_internal_core__slice__cmp__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized E&.)
     (tr_bound%core!cmp.PartialEq. T&. T& T&. T&)
     (tr_bound%core!cmp.PartialEq. E&. E& E&. E&)
    )
    (tr_bound%core!cmp.PartialEq. $ (TYPE%core!result.Result. T&. T& E&. E&) $ (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (TYPE%core!result.Result. T&. T& E&. E&)
     $ (TYPE%core!result.Result. T&. T& E&. E&)
   ))
   :qid internal_core__result__impl&__34_trait_impl_definition
   :skolemid skolem_internal_core__result__impl&__34_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.PartialEq. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%1. T&. T&) (DST T&.) (TYPE%tuple%1.
      T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%1. T&. T&) (DST T&.)
     (TYPE%tuple%1. T&. T&)
   ))
   :qid internal_core__tuple__impl&__0_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((U&. Dcr) (U& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.PartialEq. U&. U& U&. U&)
     (tr_bound%core!cmp.PartialEq. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&) (DST T&.) (TYPE%tuple%2.
      U&. U& T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&) (DST
      T&.
     ) (TYPE%tuple%2. U&. U& T&. T&)
   ))
   :qid internal_core__tuple__impl&__10_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__10_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((W&. Dcr) (W& Type) (V&. Dcr) (V& Type) (U&. Dcr) (U& Type) (T&. Dcr) (T& Type))
  (!
   (=>
    (and
     (sized W&.)
     (sized V&.)
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.PartialEq. W&. W& W&. W&)
     (tr_bound%core!cmp.PartialEq. V&. V& V&. V&)
     (tr_bound%core!cmp.PartialEq. U&. U& U&. U&)
     (tr_bound%core!cmp.PartialEq. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&)
     (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&)
   ))
   :pattern ((tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U&
      T&. T&
     ) (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&)
   ))
   :qid internal_core__tuple__impl&__30_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__30_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.PartialOrd. (CONST_PTR $) (PTR T&. T&) (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.PartialOrd. (CONST_PTR $) (PTR T&. T&) (CONST_PTR $) (
      PTR T&. T&
   )))
   :qid internal_core__ptr__const_ptr__impl&__9_trait_impl_definition
   :skolemid skolem_internal_core__ptr__const_ptr__impl&__9_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.PartialOrd. $ (PTR T&. T&) $ (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.PartialOrd. $ (PTR T&. T&) $ (PTR T&. T&)))
   :qid internal_core__ptr__mut_ptr__impl&__9_trait_impl_definition
   :skolemid skolem_internal_core__ptr__mut_ptr__impl&__9_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ TYPE%tuple%0. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ BOOL $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ CHAR $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type) (B&. Dcr) (B& Type)) (!
   (=>
    (tr_bound%core!cmp.PartialOrd. A&. A& B&. B&)
    (tr_bound%core!cmp.PartialOrd. (REF A&.) A& (REF B&.) B&)
   )
   :pattern ((tr_bound%core!cmp.PartialOrd. (REF A&.) A& (REF B&.) B&))
   :qid internal_core__cmp__impls__impl&__10_trait_impl_definition
   :skolemid skolem_internal_core__cmp__impls__impl&__10_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. $ (ARRAY T&. T& N&. N&) $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%core!cmp.PartialOrd. $ (ARRAY T&. T& N&. N&) $ (ARRAY T&. T& N&.
      N&
   )))
   :qid internal_core__array__impl&__17_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__17_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized E&.)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
     (tr_bound%core!cmp.PartialOrd. E&. E& E&. E&)
    )
    (tr_bound%core!cmp.PartialOrd. $ (TYPE%core!result.Result. T&. T& E&. E&) $ (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :pattern ((tr_bound%core!cmp.PartialOrd. $ (TYPE%core!result.Result. T&. T& E&. E&)
     $ (TYPE%core!result.Result. T&. T& E&. E&)
   ))
   :qid internal_core__result__impl&__35_trait_impl_definition
   :skolemid skolem_internal_core__result__impl&__35_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. $slice (SLICE T&. T&) $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%core!cmp.PartialOrd. $slice (SLICE T&. T&) $slice (SLICE T&. T&)))
   :qid internal_core__slice__cmp__impl&__3_trait_impl_definition
   :skolemid skolem_internal_core__slice__cmp__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $slice STRSLICE $slice STRSLICE)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%1. T&. T&) (DST T&.) (TYPE%tuple%1.
      T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%1. T&. T&) (DST T&.)
     (TYPE%tuple%1. T&. T&)
   ))
   :qid internal_core__tuple__impl&__4_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((U&. Dcr) (U& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.PartialOrd. U&. U& U&. U&)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&) (DST T&.) (
      TYPE%tuple%2. U&. U& T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&) (DST
      T&.
     ) (TYPE%tuple%2. U&. U& T&. T&)
   ))
   :qid internal_core__tuple__impl&__14_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__14_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((W&. Dcr) (W& Type) (V&. Dcr) (V& Type) (U&. Dcr) (U& Type) (T&. Dcr) (T& Type))
  (!
   (=>
    (and
     (sized W&.)
     (sized V&.)
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.PartialOrd. W&. W& W&. W&)
     (tr_bound%core!cmp.PartialOrd. V&. V& V&. V&)
     (tr_bound%core!cmp.PartialOrd. U&. U& U&. U&)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&)
     (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&)
   ))
   :pattern ((tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&.
      U& T&. T&
     ) (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&)
   ))
   :qid internal_core__tuple__impl&__34_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__34_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. T&. T& T&. T&)
   )
   :pattern ((tr_bound%core!convert.From. T&. T& T&. T&))
   :qid internal_core__convert__impl&__4_trait_impl_definition
   :skolemid skolem_internal_core__convert__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ USIZE $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 8) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 16) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 32) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 32) $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 64) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 64) $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (SINT 8) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (SINT 16) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (SINT 16) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (SINT 16) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (SINT 32) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (SINT 32) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (SINT 32) $ (SINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (SINT 32) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (SINT 32) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ CHAR $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. $ (TYPE%core!option.Option. T&. T&) T&. T&)
   )
   :pattern ((tr_bound%core!convert.From. $ (TYPE%core!option.Option. T&. T&) T&. T&))
   :qid internal_core__option__impl&__11_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__11_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. $ (TYPE%core!option.Option. (REF T&.) T&) (REF $) (TYPE%core!option.Option.
      T&. T&
   )))
   :pattern ((tr_bound%core!convert.From. $ (TYPE%core!option.Option. (REF T&.) T&) (REF
      $
     ) (TYPE%core!option.Option. T&. T&)
   ))
   :qid internal_core__option__impl&__12_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__12_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. (DST T&.) (TYPE%tuple%1. T&. T&) $ (ARRAY T&. T& $ (CONST_INT
       1
   ))))
   :pattern ((tr_bound%core!convert.From. (DST T&.) (TYPE%tuple%1. T&. T&) $ (ARRAY T&.
      T& $ (CONST_INT 1)
   )))
   :qid internal_core__tuple__impl&__7_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__7_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. $ (ARRAY T&. T& $ (CONST_INT 1)) (DST T&.) (TYPE%tuple%1.
      T&. T&
   )))
   :pattern ((tr_bound%core!convert.From. $ (ARRAY T&. T& $ (CONST_INT 1)) (DST T&.) (
      TYPE%tuple%1. T&. T&
   )))
   :qid internal_core__tuple__impl&__8_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__8_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. $ (ARRAY T&. T& $ (CONST_INT 2)) (DST T&.) (TYPE%tuple%2.
      T&. T& T&. T&
   )))
   :pattern ((tr_bound%core!convert.From. $ (ARRAY T&. T& $ (CONST_INT 2)) (DST T&.) (
      TYPE%tuple%2. T&. T& T&. T&
   )))
   :qid internal_core__tuple__impl&__18_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__18_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. $ (ARRAY T&. T& $ (CONST_INT 4)) (DST T&.) (TYPE%tuple%4.
      T&. T& T&. T& T&. T& T&. T&
   )))
   :pattern ((tr_bound%core!convert.From. $ (ARRAY T&. T& $ (CONST_INT 4)) (DST T&.) (
      TYPE%tuple%4. T&. T& T&. T& T&. T& T&. T&
   )))
   :qid internal_core__tuple__impl&__38_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__38_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. (DST T&.) (TYPE%tuple%2. T&. T& T&. T&) $ (ARRAY T&. T&
      $ (CONST_INT 2)
   )))
   :pattern ((tr_bound%core!convert.From. (DST T&.) (TYPE%tuple%2. T&. T& T&. T&) $ (ARRAY
      T&. T& $ (CONST_INT 2)
   )))
   :qid internal_core__tuple__impl&__17_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__17_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. (DST T&.) (TYPE%tuple%4. T&. T& T&. T& T&. T& T&. T&)
     $ (ARRAY T&. T& $ (CONST_INT 4))
   ))
   :pattern ((tr_bound%core!convert.From. (DST T&.) (TYPE%tuple%4. T&. T& T&. T& T&. T&
      T&. T&
     ) $ (ARRAY T&. T& $ (CONST_INT 4))
   ))
   :qid internal_core__tuple__impl&__37_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__37_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!default.Default. (REF $slice) (SLICE T&. T&))
   )
   :pattern ((tr_bound%core!default.Default. (REF $slice) (SLICE T&. T&)))
   :qid internal_core__slice__impl&__7_trait_impl_definition
   :skolemid skolem_internal_core__slice__impl&__7_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. (REF $slice) STRSLICE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ (SINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (forall ((Idx&. Dcr) (Idx& Type)) (!
   (=>
    (and
     (sized Idx&.)
     (tr_bound%core!default.Default. Idx&. Idx&)
    )
    (tr_bound%core!default.Default. $ (TYPE%core!ops.range.Range. Idx&. Idx&))
   )
   :pattern ((tr_bound%core!default.Default. $ (TYPE%core!ops.range.Range. Idx&. Idx&)))
   :qid internal_core__ops__range__impl&__47_trait_impl_definition
   :skolemid skolem_internal_core__ops__range__impl&__47_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 32)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 32))))
   :qid internal_core__array__impl&__29_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__29_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 31)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 31))))
   :qid internal_core__array__impl&__30_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__30_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 30)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 30))))
   :qid internal_core__array__impl&__31_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__31_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 29)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 29))))
   :qid internal_core__array__impl&__32_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__32_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 28)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 28))))
   :qid internal_core__array__impl&__33_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__33_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 27)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 27))))
   :qid internal_core__array__impl&__34_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__34_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 26)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 26))))
   :qid internal_core__array__impl&__35_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__35_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 25)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 25))))
   :qid internal_core__array__impl&__36_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__36_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 24)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 24))))
   :qid internal_core__array__impl&__37_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__37_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 23)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 23))))
   :qid internal_core__array__impl&__38_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__38_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 22)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 22))))
   :qid internal_core__array__impl&__39_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__39_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 21)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 21))))
   :qid internal_core__array__impl&__40_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__40_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 20)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 20))))
   :qid internal_core__array__impl&__41_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__41_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 19)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 19))))
   :qid internal_core__array__impl&__42_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__42_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 18)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 18))))
   :qid internal_core__array__impl&__43_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__43_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 17)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 17))))
   :qid internal_core__array__impl&__44_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__44_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 16)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 16))))
   :qid internal_core__array__impl&__45_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__45_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 15)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 15))))
   :qid internal_core__array__impl&__46_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__46_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 14)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 14))))
   :qid internal_core__array__impl&__47_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__47_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 13)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 13))))
   :qid internal_core__array__impl&__48_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__48_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 12)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 12))))
   :qid internal_core__array__impl&__49_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__49_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 11)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 11))))
   :qid internal_core__array__impl&__50_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__50_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 10)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 10))))
   :qid internal_core__array__impl&__51_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__51_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 9)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 9))))
   :qid internal_core__array__impl&__52_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__52_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 8)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 8))))
   :qid internal_core__array__impl&__53_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__53_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 7)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 7))))
   :qid internal_core__array__impl&__54_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__54_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 6)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 6))))
   :qid internal_core__array__impl&__55_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__55_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 5)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 5))))
   :qid internal_core__array__impl&__56_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__56_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 4)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 4))))
   :qid internal_core__array__impl&__57_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__57_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 3)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 3))))
   :qid internal_core__array__impl&__58_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__58_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 2)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 2))))
   :qid internal_core__array__impl&__59_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__59_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 1)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 1))))
   :qid internal_core__array__impl&__60_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__60_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 0)))
   )
   :pattern ((tr_bound%core!default.Default. $ (ARRAY T&. T& $ (CONST_INT 0))))
   :qid internal_core__array__impl&__61_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__61_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!default.Default. $ (TYPE%core!option.Option. T&. T&))
   )
   :pattern ((tr_bound%core!default.Default. $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_core__option__impl&__7_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__7_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. (DST T&.) (TYPE%tuple%1. T&. T&))
   )
   :pattern ((tr_bound%core!default.Default. (DST T&.) (TYPE%tuple%1. T&. T&)))
   :qid internal_core__tuple__impl&__6_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((U&. Dcr) (U& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized U&.)
     (sized T&.)
     (tr_bound%core!default.Default. U&. U&)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&))
   )
   :pattern ((tr_bound%core!default.Default. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&)))
   :qid internal_core__tuple__impl&__16_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__16_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((W&. Dcr) (W& Type) (V&. Dcr) (V& Type) (U&. Dcr) (U& Type) (T&. Dcr) (T& Type))
  (!
   (=>
    (and
     (sized W&.)
     (sized V&.)
     (sized U&.)
     (sized T&.)
     (tr_bound%core!default.Default. W&. W&)
     (tr_bound%core!default.Default. V&. V&)
     (tr_bound%core!default.Default. U&. U&)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&))
   )
   :pattern ((tr_bound%core!default.Default. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&.
      U& T&. T&
   )))
   :qid internal_core__tuple__impl&__36_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__36_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ ALLOCATOR_GLOBAL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 16) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 16) (REF $) (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 32) (REF $) (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (SINT 8) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (SINT 8) (REF $) (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (SINT 16) $ (SINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (SINT 16) (REF $) (SINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 16) (REF $) (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 32) (REF $) (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (SINT 8) (REF $) (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (SINT 16) (REF $) (SINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (forall ((I&. Dcr) (I& Type)) (!
   (=>
    (and
     (sized I&.)
     (tr_bound%core!slice.index.SliceIndex. I&. I& $slice STRSLICE)
    )
    (tr_bound%core!ops.index.Index. $slice STRSLICE I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.Index. $slice STRSLICE I&. I&))
   :qid internal_core__str__traits__impl&__4_trait_impl_definition
   :skolemid skolem_internal_core__str__traits__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((I&. Dcr) (I& Type)) (!
   (=>
    (and
     (sized I&.)
     (tr_bound%core!slice.index.SliceIndex. I&. I& $slice STRSLICE)
    )
    (tr_bound%core!ops.index.IndexMut. $slice STRSLICE I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.IndexMut. $slice STRSLICE I&. I&))
   :qid internal_core__str__traits__impl&__5_trait_impl_definition
   :skolemid skolem_internal_core__str__traits__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (SINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%core!iter.range.Step. A&. A&)
    )
    (tr_bound%core!iter.traits.iterator.Iterator. $ (TYPE%core!ops.range.Range. A&. A&))
   )
   :pattern ((tr_bound%core!iter.traits.iterator.Iterator. $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_core__iter__range__impl&__6_trait_impl_definition
   :skolemid skolem_internal_core__iter__range__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((Idx&. Dcr) (Idx& Type)) (!
   (=>
    (and
     (sized Idx&.)
     (tr_bound%core!fmt.Debug. Idx&. Idx&)
    )
    (tr_bound%core!fmt.Debug. $ (TYPE%core!ops.range.Range. Idx&. Idx&))
   )
   :pattern ((tr_bound%core!fmt.Debug. $ (TYPE%core!ops.range.Range. Idx&. Idx&)))
   :qid internal_core__ops__range__impl&__1_trait_impl_definition
   :skolemid skolem_internal_core__ops__range__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!fmt.Debug. T&. T&)
    )
    (tr_bound%core!fmt.Debug. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%core!fmt.Debug. $ (ARRAY T&. T& N&. N&)))
   :qid internal_core__array__impl&__12_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__12_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!fmt.Debug. T&. T&)
    )
    (tr_bound%core!fmt.Debug. $ (TYPE%core!option.Option. T&. T&))
   )
   :pattern ((tr_bound%core!fmt.Debug. $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_core__option__impl&__46_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__46_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized E&.)
     (tr_bound%core!fmt.Debug. T&. T&)
     (tr_bound%core!fmt.Debug. E&. E&)
    )
    (tr_bound%core!fmt.Debug. $ (TYPE%core!result.Result. T&. T& E&. E&))
   )
   :pattern ((tr_bound%core!fmt.Debug. $ (TYPE%core!result.Result. T&. T& E&. E&)))
   :qid internal_core__result__impl&__31_trait_impl_definition
   :skolemid skolem_internal_core__result__impl&__31_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ (SINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%core!fmt.Debug. T&. T&)
    (tr_bound%core!fmt.Debug. (REF T&.) T&)
   )
   :pattern ((tr_bound%core!fmt.Debug. (REF T&.) T&))
   :qid internal_core__fmt__impl&__73_trait_impl_definition
   :skolemid skolem_internal_core__fmt__impl&__73_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $slice STRSLICE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!fmt.Debug. (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%core!fmt.Debug. (CONST_PTR $) (PTR T&. T&)))
   :qid internal_core__fmt__impl&__26_trait_impl_definition
   :skolemid skolem_internal_core__fmt__impl&__26_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!fmt.Debug. $ (PTR T&. T&))
   :pattern ((tr_bound%core!fmt.Debug. $ (PTR T&. T&)))
   :qid internal_core__fmt__impl&__27_trait_impl_definition
   :skolemid skolem_internal_core__fmt__impl&__27_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((W&. Dcr) (W& Type) (V&. Dcr) (V& Type) (U&. Dcr) (U& Type) (T&. Dcr) (T& Type))
  (!
   (=>
    (and
     (sized W&.)
     (sized V&.)
     (sized U&.)
     (sized T&.)
     (tr_bound%core!fmt.Debug. W&. W&)
     (tr_bound%core!fmt.Debug. V&. V&)
     (tr_bound%core!fmt.Debug. U&. U&)
     (tr_bound%core!fmt.Debug. T&. T&)
    )
    (tr_bound%core!fmt.Debug. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&))
   )
   :pattern ((tr_bound%core!fmt.Debug. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&.
      T&
   )))
   :qid internal_core__fmt__impl&__97_trait_impl_definition
   :skolemid skolem_internal_core__fmt__impl&__97_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((U&. Dcr) (U& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized U&.)
     (sized T&.)
     (tr_bound%core!fmt.Debug. U&. U&)
     (tr_bound%core!fmt.Debug. T&. T&)
    )
    (tr_bound%core!fmt.Debug. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&))
   )
   :pattern ((tr_bound%core!fmt.Debug. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&)))
   :qid internal_core__fmt__impl&__99_trait_impl_definition
   :skolemid skolem_internal_core__fmt__impl&__99_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!fmt.Debug. T&. T&)
    )
    (tr_bound%core!fmt.Debug. (DST T&.) (TYPE%tuple%1. T&. T&))
   )
   :pattern ((tr_bound%core!fmt.Debug. (DST T&.) (TYPE%tuple%1. T&. T&)))
   :qid internal_core__fmt__impl&__100_trait_impl_definition
   :skolemid skolem_internal_core__fmt__impl&__100_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!fmt.Debug. T&. T&)
    )
    (tr_bound%core!fmt.Debug. $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%core!fmt.Debug. $slice (SLICE T&. T&)))
   :qid internal_core__fmt__impl&__28_trait_impl_definition
   :skolemid skolem_internal_core__fmt__impl&__28_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ ALLOCATOR_GLOBAL)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!slice.index.SliceIndex. $ (TYPE%core!ops.range.Range. $ USIZE) $slice
     (SLICE T&. T&)
   ))
   :pattern ((tr_bound%core!slice.index.SliceIndex. $ (TYPE%core!ops.range.Range. $ USIZE)
     $slice (SLICE T&. T&)
   ))
   :qid internal_core__slice__index__impl&__4_trait_impl_definition
   :skolemid skolem_internal_core__slice__index__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!slice.index.SliceIndex. $ (TYPE%core!ops.range.Range. $ USIZE) $slice
  STRSLICE
))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%core!alloc.Allocator. A&. A&)
    (tr_bound%core!alloc.Allocator. (REF A&.) A&)
   )
   :pattern ((tr_bound%core!alloc.Allocator. (REF A&.) A&))
   :qid internal_core__alloc__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__alloc__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (sized A&.)
    (tr_bound%core!clone.Clone. (TRACKED A&.) A&)
   )
   :pattern ((tr_bound%core!clone.Clone. (TRACKED A&.) A&))
   :qid internal_verus_builtin__impl&__5_trait_impl_definition
   :skolemid skolem_internal_verus_builtin__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (sized A&.)
    (tr_bound%core!clone.Clone. (GHOST A&.) A&)
   )
   :pattern ((tr_bound%core!clone.Clone. (GHOST A&.) A&))
   :qid internal_verus_builtin__impl&__3_trait_impl_definition
   :skolemid skolem_internal_verus_builtin__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!clone.Clone. T&. T&)
    )
    (tr_bound%core!clone.Clone. $ (TYPE%core!option.Option. T&. T&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_core__option__impl&__5_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. (BOX $ ALLOCATOR_GLOBAL T&.) T&)
   )
   :pattern ((tr_bound%core!default.Default. (BOX $ ALLOCATOR_GLOBAL T&.) T&))
   :qid internal_alloc__boxed__impl&__9_trait_impl_definition
   :skolemid skolem_internal_alloc__boxed__impl&__9_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. (RC $ ALLOCATOR_GLOBAL T&.) T&)
   )
   :pattern ((tr_bound%core!default.Default. (RC $ ALLOCATOR_GLOBAL T&.) T&))
   :qid internal_alloc__rc__impl&__36_trait_impl_definition
   :skolemid skolem_internal_alloc__rc__impl&__36_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!default.Default. T&. T&)
    )
    (tr_bound%core!default.Default. (ARC $ ALLOCATOR_GLOBAL T&.) T&)
   )
   :pattern ((tr_bound%core!default.Default. (ARC $ ALLOCATOR_GLOBAL T&.) T&))
   :qid internal_alloc__sync__impl&__60_trait_impl_definition
   :skolemid skolem_internal_alloc__sync__impl&__60_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized A&.)
     (tr_bound%core!clone.Clone. T&. T&)
     (tr_bound%core!alloc.Allocator. A&. A&)
     (tr_bound%core!clone.Clone. A&. A&)
    )
    (tr_bound%core!clone.Clone. (BOX A&. A& T&.) T&)
   )
   :pattern ((tr_bound%core!clone.Clone. (BOX A&. A& T&.) T&))
   :qid internal_alloc__boxed__impl&__13_trait_impl_definition
   :skolemid skolem_internal_alloc__boxed__impl&__13_trait_impl_definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::add_lemmas::lemma_sum_of_limbs_bounded_from_fe51_bounded
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.
  Int
 ) Bool
)
(declare-const %%global_location_label%%18 Bool)
(declare-const %%global_location_label%%19 Bool)
(declare-const %%global_location_label%%20 Bool)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (b! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (n! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded.
     a! b! n!
    ) (and
     (=>
      %%global_location_label%%18
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        a!
       ) (I n!)
     ))
     (=>
      %%global_location_label%%19
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        b!
       ) (I n!)
     ))
     (=>
      %%global_location_label%%20
      (<= n! 62)
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded.
     a! b! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.
  Int
 ) Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (b! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (n! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded.
     a! b! n!
    ) (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      a!
     ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!) (I 18446744073709551615)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded.
     a! b! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_sum_of_limbs_bounded_from_fe51_bounded._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::impl&%6::add
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%6.add. (Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (_rhs! Poly) (output! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%6.add. self! _rhs! output!)
    (and
     (ens%core!ops.arith.Add.add. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! _rhs!
      output!
     )
     (= (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. output!) (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?
       self! _rhs!
     ))
     (= (curve25519_dalek!specs.field_specs.fe51_as_nat.? output!) (nClip (Add (curve25519_dalek!specs.field_specs.fe51_as_nat.?
         self!
        ) (curve25519_dalek!specs.field_specs.fe51_as_nat.? _rhs!)
     )))
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? output!) (curve25519_dalek!specs.field_specs.field_add.?
       (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? self!)) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         _rhs!
     ))))
     (=>
      (and
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? self! (I 51))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? _rhs! (I 51))
      )
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 52))
     )
     (=>
      (and
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? self! (I 52))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? _rhs! (I 52))
      )
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 53))
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%6.add. self! _rhs! output!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__6.add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__6.add._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Specs curve25519_dalek::edwards::EdwardsPoint::clone
(declare-fun ens%curve25519_dalek!edwards.impl&%14.clone. (Poly Poly) Bool)
(assert
 (forall ((self! Poly) (%return! Poly)) (!
   (= (ens%curve25519_dalek!edwards.impl&%14.clone. self! %return!) (and
     (ens%core!clone.Clone.clone. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. self! %return!)
     (= %return! self!)
   ))
   :pattern ((ens%curve25519_dalek!edwards.impl&%14.clone. self! %return!))
   :qid internal_ens__curve25519_dalek!edwards.impl&__14.clone._definition
   :skolemid skolem_internal_ens__curve25519_dalek!edwards.impl&__14.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (%return$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.))
     (has_type %return$ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      (F fndef_singleton) closure%$ %return$
     )
     (let
      ((self$ (%Poly%curve25519_dalek!edwards.EdwardsPoint. (tuple%1./tuple%1/0 (%Poly%tuple%1.
           closure%$
      )))))
      (= (%Poly%curve25519_dalek!edwards.EdwardsPoint. %return$) self$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (F fndef_singleton) closure%$ %return$
   ))
   :qid user_curve25519_dalek__edwards__EdwardsPoint__clone_90
   :skolemid skolem_user_curve25519_dalek__edwards__EdwardsPoint__clone_90
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
)

;; Function-Specs curve25519_dalek::specs::edwards_specs::lemma_unfold_edwards
(declare-fun ens%curve25519_dalek!specs.edwards_specs.lemma_unfold_edwards. (curve25519_dalek!edwards.EdwardsPoint.)
 Bool
)
(assert
 (forall ((point! curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (ens%curve25519_dalek!specs.edwards_specs.lemma_unfold_edwards. point!) (and
     (= (curve25519_dalek!specs.edwards_specs.edwards_x.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        point!
       )
      ) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X (%Poly%curve25519_dalek!edwards.EdwardsPoint.
        (Poly%curve25519_dalek!edwards.EdwardsPoint. point!)
     )))
     (= (curve25519_dalek!specs.edwards_specs.edwards_y.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        point!
       )
      ) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y (%Poly%curve25519_dalek!edwards.EdwardsPoint.
        (Poly%curve25519_dalek!edwards.EdwardsPoint. point!)
     )))
     (= (curve25519_dalek!specs.edwards_specs.edwards_z.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        point!
       )
      ) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z (%Poly%curve25519_dalek!edwards.EdwardsPoint.
        (Poly%curve25519_dalek!edwards.EdwardsPoint. point!)
     )))
     (= (curve25519_dalek!specs.edwards_specs.edwards_t.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        point!
       )
      ) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T (%Poly%curve25519_dalek!edwards.EdwardsPoint.
        (Poly%curve25519_dalek!edwards.EdwardsPoint. point!)
   )))))
   :pattern ((ens%curve25519_dalek!specs.edwards_specs.lemma_unfold_edwards. point!))
   :qid internal_ens__curve25519_dalek!specs.edwards_specs.lemma_unfold_edwards._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.edwards_specs.lemma_unfold_edwards._definition
)))

;; Function-Specs curve25519_dalek::edwards::EdwardsPoint::identity
(declare-fun ens%curve25519_dalek!edwards.impl&%19.identity. (Poly) Bool)
(assert
 (forall ((result! Poly)) (!
   (= (ens%curve25519_dalek!edwards.impl&%19.identity. result!) (and
     (ens%curve25519_dalek!traits.Identity.identity. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
      result!
     )
     (curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.? result!)
     (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? result!)
     (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? result!) (curve25519_dalek!specs.edwards_specs.edwards_identity.?
       (I 0)
   ))))
   :pattern ((ens%curve25519_dalek!edwards.impl&%19.identity. result!))
   :qid internal_ens__curve25519_dalek!edwards.impl&__19.identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!edwards.impl&__19.identity._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%curve25519_dalek!traits.Identity. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
)

;; Function-Specs curve25519_dalek::edwards::EdwardsPoint::default
(declare-fun ens%curve25519_dalek!edwards.impl&%20.default. (Poly) Bool)
(assert
 (forall ((result! Poly)) (!
   (= (ens%curve25519_dalek!edwards.impl&%20.default. result!) (and
     (ens%core!default.Default.default. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. result!)
     (curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.? result!)
   ))
   :pattern ((ens%curve25519_dalek!edwards.impl&%20.default. result!))
   :qid internal_ens__curve25519_dalek!edwards.impl&__20.default._definition
   :skolemid skolem_internal_ens__curve25519_dalek!edwards.impl&__20.default._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type result$ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      $ TYPE%tuple%0. (F fndef_singleton) closure%$ result$
     )
     (curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.? result$)
   ))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     $ TYPE%tuple%0. (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__edwards__EdwardsPoint__default_91
   :skolemid skolem_user_curve25519_dalek__edwards__EdwardsPoint__default_91
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
)

;; Function-Specs curve25519_dalek::edwards::EdwardsPoint::as_projective_niels
(declare-fun req%curve25519_dalek!edwards.impl&%29.as_projective_niels. (curve25519_dalek!edwards.EdwardsPoint.)
 Bool
)
(declare-const %%global_location_label%%21 Bool)
(declare-const %%global_location_label%%22 Bool)
(declare-const %%global_location_label%%23 Bool)
(assert
 (forall ((self! curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (req%curve25519_dalek!edwards.impl&%29.as_projective_niels. self!) (and
     (=>
      %%global_location_label%%21
      (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        self!
     )))
     (=>
      %%global_location_label%%22
      (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y (%Poly%curve25519_dalek!edwards.EdwardsPoint.
          (Poly%curve25519_dalek!edwards.EdwardsPoint. self!)
        ))
       ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X
         (%Poly%curve25519_dalek!edwards.EdwardsPoint. (Poly%curve25519_dalek!edwards.EdwardsPoint.
           self!
        )))
       ) (I 18446744073709551615)
     ))
     (=>
      %%global_location_label%%23
      (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        self!
   )))))
   :pattern ((req%curve25519_dalek!edwards.impl&%29.as_projective_niels. self!))
   :qid internal_req__curve25519_dalek!edwards.impl&__29.as_projective_niels._definition
   :skolemid skolem_internal_req__curve25519_dalek!edwards.impl&__29.as_projective_niels._definition
)))
(declare-fun ens%curve25519_dalek!edwards.impl&%29.as_projective_niels. (curve25519_dalek!edwards.EdwardsPoint.
  curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!edwards.EdwardsPoint.) (result! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
  (!
   (= (ens%curve25519_dalek!edwards.impl&%29.as_projective_niels. self! result!) (and
     (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       result!
      ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
     )
     (curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       result!
      ) (Poly%curve25519_dalek!edwards.EdwardsPoint. self!)
     )
     (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       result!
     ))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
   )))
   :pattern ((ens%curve25519_dalek!edwards.impl&%29.as_projective_niels. self! result!))
   :qid internal_ens__curve25519_dalek!edwards.impl&__29.as_projective_niels._definition
   :skolemid skolem_internal_ens__curve25519_dalek!edwards.impl&__29.as_projective_niels._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_projective_niels_affine_equals_edwards_affine
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine.
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. curve25519_dalek!edwards.EdwardsPoint.)
 Bool
)
(declare-const %%global_location_label%%24 Bool)
(declare-const %%global_location_label%%25 Bool)
(assert
 (forall ((niels! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   (point! curve25519_dalek!edwards.EdwardsPoint.)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine.
     niels! point!
    ) (and
     (=>
      %%global_location_label%%24
      (curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
        niels!
       ) (Poly%curve25519_dalek!edwards.EdwardsPoint. point!)
     ))
     (=>
      %%global_location_label%%25
      (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        point!
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine.
     niels! point!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine.
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. curve25519_dalek!edwards.EdwardsPoint.)
 Bool
)
(assert
 (forall ((niels! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   (point! curve25519_dalek!edwards.EdwardsPoint.)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine.
     niels! point!
    ) (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
      (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
     ) (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       point!
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine.
     niels! point!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::curve_models::impl&%29::add
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%29.add. (Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (other! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%29.add. self! other! result!)
    (and
     (ens%core!ops.arith.Add.add. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. (
       REF $
      ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. self! other!
      result!
     )
     (curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? result!)
     (= (curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.? result!)
      (let
       ((self_affine$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? self!)))
       (let
        ((other_affine$ (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
           other!
        )))
        (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
           (Poly%tuple%2. self_affine$)
          )
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. self_affine$))) (tuple%2./tuple%2/0
          (%Poly%tuple%2. (Poly%tuple%2. other_affine$))
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. other_affine$)))
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%29.add. self! other!
     result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__29.add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__29.add._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::curve_models::CompletedPoint::as_extended
(declare-fun req%curve25519_dalek!backend.serial.curve_models.impl&%26.as_extended.
 (curve25519_dalek!backend.serial.curve_models.CompletedPoint.) Bool
)
(declare-const %%global_location_label%%26 Bool)
(declare-const %%global_location_label%%27 Bool)
(declare-const %%global_location_label%%28 Bool)
(declare-const %%global_location_label%%29 Bool)
(declare-const %%global_location_label%%30 Bool)
(assert
 (forall ((self! curve25519_dalek!backend.serial.curve_models.CompletedPoint.)) (!
   (= (req%curve25519_dalek!backend.serial.curve_models.impl&%26.as_extended. self!)
    (and
     (=>
      %%global_location_label%%26
      (curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
        self!
     )))
     (=>
      %%global_location_label%%27
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
          (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. self!)
        ))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%28
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
          (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. self!)
        ))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%29
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
          (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. self!)
        ))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%30
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
          (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. self!)
        ))
       ) (I 54)
   ))))
   :pattern ((req%curve25519_dalek!backend.serial.curve_models.impl&%26.as_extended. self!))
   :qid internal_req__curve25519_dalek!backend.serial.curve_models.impl&__26.as_extended._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.curve_models.impl&__26.as_extended._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%26.as_extended.
 (curve25519_dalek!backend.serial.curve_models.CompletedPoint. curve25519_dalek!edwards.EdwardsPoint.)
 Bool
)
(assert
 (forall ((self! curve25519_dalek!backend.serial.curve_models.CompletedPoint.) (result!
    curve25519_dalek!edwards.EdwardsPoint.
   )
  ) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%26.as_extended. self! result!)
    (and
     (has_type (Poly%curve25519_dalek!edwards.EdwardsPoint. result!) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       result!
     ))
     (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       result!
     ))
     (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       result!
     ))
     (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        result!
       )
      ) (curve25519_dalek!specs.edwards_specs.completed_to_extended.? (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
        self!
     )))
     (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        result!
       )
      ) (curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.? (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
        self!
   )))))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%26.as_extended. self!
     result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__26.as_extended._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__26.as_extended._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
))

;; Function-Specs curve25519_dalek::edwards::impl&%32::add
(declare-fun ens%curve25519_dalek!edwards.impl&%32.add. (Poly Poly Poly) Bool)
(assert
 (forall ((self! Poly) (other! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!edwards.impl&%32.add. self! other! result!) (and
     (ens%core!ops.arith.Add.add. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. (
       REF $
      ) TYPE%curve25519_dalek!edwards.EdwardsPoint. self! other! result!
     )
     (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? result!)
     (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? self!)))
      (let
       ((x1$ (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
       (let
        ((y1$ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
        (let
         ((tmp%%$1 (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? other!)))
         (let
          ((x2$ (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$1))))))
          (let
           ((y2$ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$1))))))
           (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? result!) (curve25519_dalek!specs.edwards_specs.edwards_add.?
             (I x1$) (I y1$) (I x2$) (I y2$)
   ))))))))))
   :pattern ((ens%curve25519_dalek!edwards.impl&%32.add. self! other! result!))
   :qid internal_ens__curve25519_dalek!edwards.impl&__32.add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!edwards.impl&__32.add._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_add_commutative
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_commutative.
 (Int Int Int Int) Bool
)
(assert
 (forall ((x1! Int) (y1! Int) (x2! Int) (y2! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_commutative.
     x1! y1! x2! y2!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x1!) (I y1!) (I x2!) (I
       y2!
      )
     ) (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x2!) (I y2!) (I x1!) (I y1!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_commutative.
     x1! y1! x2! y2!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_commutative._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_commutative._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_scalar_mul_succ
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
 (tuple%2. Int) Bool
)
(declare-const %%global_location_label%%31 Bool)
(assert
 (forall ((point_affine! tuple%2.) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
     point_affine! n!
    ) (=>
     %%global_location_label%%31
     (>= n! 1)
   ))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
     point_affine! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
 (tuple%2. Int) Bool
)
(assert
 (forall ((point_affine! tuple%2.) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
     point_affine! n!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine!)
      (I (nClip (Add n! 1)))
     ) (let
      ((prev$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine!)
         (I n!)
      )))
      (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
         (Poly%tuple%2. prev$)
        )
       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
        (%Poly%tuple%2. (Poly%tuple%2. point_affine!))
       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. point_affine!)))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
     point_affine! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ._definition
)))

;; Function-Specs curve25519_dalek::window::LookupTable::from
(declare-fun ens%curve25519_dalek!window.impl&%12.from. (Poly Poly) Bool)
(assert
 (forall ((P! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!window.impl&%12.from. P! result!) (and
     (ens%core!convert.From.from. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. P! result!
     )
     (curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.? $ (CONST_INT
       8
      ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
         result!
       ))
      ) P! (I 8)
     )
     (curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.? $ (CONST_INT
       8
      ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
         result!
     ))))
     (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (vstd!seq.Seq.index.?
           $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
            $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             $ (CONST_INT 8)
            ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
               result!
            )))
           ) j$
       ))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 8)
          ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
             result!
          )))
         ) j$
       ))
       :qid user_curve25519_dalek__window__LookupTable__from_92
       :skolemid skolem_user_curve25519_dalek__window__LookupTable__from_92
   ))))
   :pattern ((ens%curve25519_dalek!window.impl&%12.from. P! result!))
   :qid internal_ens__curve25519_dalek!window.impl&__12.from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__12.from._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.))
     (has_type result$ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.LookupTable.
        $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      (F fndef_singleton) closure%$ result$
     )
     (let
      ((P$ (%Poly%curve25519_dalek!edwards.EdwardsPoint. (tuple%1./tuple%1/0 (%Poly%tuple%1.
           closure%$
      )))))
      (and
       (and
        (curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.? $ (CONST_INT
          8
         ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
            result$
          ))
         ) (Poly%curve25519_dalek!edwards.EdwardsPoint. P$) (I 8)
        )
        (curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.? $ (CONST_INT
          8
         ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
            result$
       )))))
       (forall ((j$ Poly)) (!
         (=>
          (has_type j$ INT)
          (=>
           (let
            ((tmp%%$ (%I j$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ 8)
           ))
           (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (vstd!seq.Seq.index.?
             $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
              $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
               $ (CONST_INT 8)
              ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                 result$
              )))
             ) j$
         ))))
         :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             $ (CONST_INT 8)
            ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
               result$
            )))
           ) j$
         ))
         :qid user_curve25519_dalek__window__LookupTable__from_93
         :skolemid skolem_user_curve25519_dalek__window__LookupTable__from_93
   ))))))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
     ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__window__LookupTable__from_94
   :skolemid skolem_user_curve25519_dalek__window__LookupTable__from_94
)))

;; Function-Specs curve25519_dalek::backend::serial::curve_models::ProjectiveNielsPoint::identity
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%18.identity. (
  Poly
 ) Bool
)
(assert
 (forall ((result! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%18.identity. result!) (
     and
     (ens%curve25519_dalek!traits.Identity.identity. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      result!
     )
     (= (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. result!)
      (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%18.identity. result!))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__18.identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__18.identity._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_identity_projective_niels_valid
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_niels_valid.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_niels_valid.
     no%param
    ) (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_niels_valid.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_niels_valid._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_niels_valid._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::curve_models::ProjectiveNielsPoint::clone
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%15.clone. (Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (%return! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%15.clone. self! %return!)
    (and
     (ens%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      self! %return!
     )
     (= %return! self!)
   ))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%15.clone. self! %return!))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__15.clone._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__15.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (%return$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
     (has_type %return$ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
      (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
      (F fndef_singleton) closure%$ %return$
     )
     (let
      ((self$ (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (tuple%1./tuple%1/0
          (%Poly%tuple%1. closure%$)
      ))))
      (= (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. %return$)
       self$
   ))))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
     (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
     (F fndef_singleton) closure%$ %return$
   ))
   :qid user_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint__clone_107
   :skolemid skolem_user_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint__clone_107
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
)

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_negate_projective_niels_preserves_validity
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity.
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) Bool
)
(declare-const %%global_location_label%%32 Bool)
(declare-const %%global_location_label%%33 Bool)
(declare-const %%global_location_label%%34 Bool)
(declare-const %%global_location_label%%35 Bool)
(declare-const %%global_location_label%%36 Bool)
(assert
 (forall ((pt! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
  (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity.
     pt!
    ) (and
     (=>
      %%global_location_label%%32
      (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
        pt!
     )))
     (=>
      %%global_location_label%%33
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           pt!
        )))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%34
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           pt!
        )))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%35
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           pt!
        )))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%36
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           pt!
        )))
       ) (I 54)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity.
     pt!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity.
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) Bool
)
(assert
 (forall ((pt! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
  (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity.
     pt!
    ) (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!specs.edwards_specs.negate_projective_niels.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
        pt!
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity.
     pt!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%curve25519_dalek!traits.Identity. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
)

;; Function-Specs curve25519_dalek::window::LookupTable::select
(declare-fun req%curve25519_dalek!window.impl&%7.select. (curve25519_dalek!window.LookupTable.
  Int
 ) Bool
)
(declare-const %%global_location_label%%37 Bool)
(declare-const %%global_location_label%%38 Bool)
(declare-const %%global_location_label%%39 Bool)
(declare-const %%global_location_label%%40 Bool)
(assert
 (forall ((self! curve25519_dalek!window.LookupTable.) (x! Int)) (!
   (= (req%curve25519_dalek!window.impl&%7.select. self! x!) (and
     (=>
      %%global_location_label%%37
      (<= (Sub 0 8) x!)
     )
     (=>
      %%global_location_label%%38
      (<= x! 8)
     )
     (=>
      %%global_location_label%%39
      (curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.? $ (CONST_INT
        8
       ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
          (Poly%curve25519_dalek!window.LookupTable. self!)
     )))))
     (=>
      %%global_location_label%%40
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 8)
          ))
          (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (vstd!seq.Seq.index.?
            $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
             $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              $ (CONST_INT 8)
             ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                (Poly%curve25519_dalek!window.LookupTable. self!)
             )))
            ) j$
        ))))
        :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
            $ (CONST_INT 8)
           ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
              (Poly%curve25519_dalek!window.LookupTable. self!)
           )))
          ) j$
        ))
        :qid user_curve25519_dalek__window__LookupTable__select_108
        :skolemid skolem_user_curve25519_dalek__window__LookupTable__select_108
   )))))
   :pattern ((req%curve25519_dalek!window.impl&%7.select. self! x!))
   :qid internal_req__curve25519_dalek!window.impl&__7.select._definition
   :skolemid skolem_internal_req__curve25519_dalek!window.impl&__7.select._definition
)))
(declare-fun ens%curve25519_dalek!window.impl&%7.select. (curve25519_dalek!window.LookupTable.
  Int curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!window.LookupTable.) (x! Int) (result! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
  (!
   (= (ens%curve25519_dalek!window.impl&%7.select. self! x! result!) (and
     (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       result!
      ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
     )
     (=>
      (> x! 0)
      (= result! (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
        (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 8)
          ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
             (Poly%curve25519_dalek!window.LookupTable. self!)
          )))
         ) (I (Sub x! 1))
     ))))
     (=>
      (= x! 0)
      (= result! (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? (I 0)))
     )
     (=>
      (< x! 0)
      (= result! (curve25519_dalek!specs.edwards_specs.negate_projective_niels.? (vstd!seq.Seq.index.?
         $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
          $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 8)
          ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
             (Poly%curve25519_dalek!window.LookupTable. self!)
          )))
         ) (I (Sub (Sub 0 x!) 1))
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       result!
   ))))
   :pattern ((ens%curve25519_dalek!window.impl&%7.select. self! x! result!))
   :qid internal_ens__curve25519_dalek!window.impl&__7.select._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__7.select._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_scalar_mul_additive
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive.
 (tuple%2. Int Int) Bool
)
(declare-const %%global_location_label%%41 Bool)
(declare-const %%global_location_label%%42 Bool)
(assert
 (forall ((point_affine! tuple%2.) (m! Int) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive.
     point_affine! m! n!
    ) (and
     (=>
      %%global_location_label%%41
      (>= m! 1)
     )
     (=>
      %%global_location_label%%42
      (>= n! 1)
   )))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive.
     point_affine! m! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive.
 (tuple%2. Int Int) Bool
)
(assert
 (forall ((point_affine! tuple%2.) (m! Int) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive.
     point_affine! m! n!
    ) (= (let
      ((pm$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine!)
         (I m!)
      )))
      (let
       ((pn$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine!)
          (I n!)
       )))
       (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. pm$)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. pm$))) (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. pn$)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. pn$)))
      ))
     ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine!)
      (I (nClip (Add m! n!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive.
     point_affine! m! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (TYPE%curve25519_dalek!window.LookupTable.
   $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Function-Specs curve25519_dalek::backend::serial::curve_models::AffineNielsPoint::identity
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%20.identity. (
  Poly
 ) Bool
)
(assert
 (forall ((result! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%20.identity. result!) (
     and
     (ens%curve25519_dalek!traits.Identity.identity. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      result!
     )
     (= (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. result!)
      (curve25519_dalek!specs.edwards_specs.identity_affine_niels.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%20.identity. result!))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__20.identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__20.identity._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_identity_affine_niels_valid
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_affine_niels_valid.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_affine_niels_valid.
     no%param
    ) (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      (curve25519_dalek!specs.edwards_specs.identity_affine_niels.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_affine_niels_valid.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_affine_niels_valid._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_affine_niels_valid._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::curve_models::AffineNielsPoint::clone
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%9.clone. (Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (%return! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%9.clone. self! %return!)
    (and
     (ens%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      self! %return!
     )
     (= %return! self!)
   ))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%9.clone. self! %return!))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__9.clone._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__9.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (%return$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
     (has_type %return$ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
      (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
      (F fndef_singleton) closure%$ %return$
     )
     (let
      ((self$ (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (tuple%1./tuple%1/0
          (%Poly%tuple%1. closure%$)
      ))))
      (= (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. %return$)
       self$
   ))))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
     (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
     (F fndef_singleton) closure%$ %return$
   ))
   :qid user_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint__clone_113
   :skolemid skolem_user_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint__clone_113
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
)

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_negate_affine_niels_preserves_validity
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_affine_niels_preserves_validity.
 (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.) Bool
)
(declare-const %%global_location_label%%43 Bool)
(declare-const %%global_location_label%%44 Bool)
(declare-const %%global_location_label%%45 Bool)
(declare-const %%global_location_label%%46 Bool)
(assert
 (forall ((pt! curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_affine_niels_preserves_validity.
     pt!
    ) (and
     (=>
      %%global_location_label%%43
      (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
        pt!
     )))
     (=>
      %%global_location_label%%44
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
         (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           pt!
        )))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%45
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
         (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           pt!
        )))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%46
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
         (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           pt!
        )))
       ) (I 54)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_affine_niels_preserves_validity.
     pt!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_affine_niels_preserves_validity._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_affine_niels_preserves_validity._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_affine_niels_preserves_validity.
 (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.) Bool
)
(assert
 (forall ((pt! curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_affine_niels_preserves_validity.
     pt!
    ) (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      (curve25519_dalek!specs.edwards_specs.negate_affine_niels.? (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
        pt!
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_affine_niels_preserves_validity.
     pt!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_affine_niels_preserves_validity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_affine_niels_preserves_validity._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%curve25519_dalek!traits.Identity. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
)

;; Function-Specs curve25519_dalek::window::LookupTable::select
(declare-fun req%curve25519_dalek!window.impl&%6.select. (curve25519_dalek!window.LookupTable.
  Int
 ) Bool
)
(declare-const %%global_location_label%%47 Bool)
(declare-const %%global_location_label%%48 Bool)
(declare-const %%global_location_label%%49 Bool)
(declare-const %%global_location_label%%50 Bool)
(assert
 (forall ((self! curve25519_dalek!window.LookupTable.) (x! Int)) (!
   (= (req%curve25519_dalek!window.impl&%6.select. self! x!) (and
     (=>
      %%global_location_label%%47
      (<= (Sub 0 8) x!)
     )
     (=>
      %%global_location_label%%48
      (<= x! 8)
     )
     (=>
      %%global_location_label%%49
      (curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.? $ (CONST_INT
        8
       ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
          (Poly%curve25519_dalek!window.LookupTable. self!)
     )))))
     (=>
      %%global_location_label%%50
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 8)
          ))
          (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? (vstd!seq.Seq.index.?
            $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
             $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. $ (
               CONST_INT 8
              )
             ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                (Poly%curve25519_dalek!window.LookupTable. self!)
             )))
            ) j$
        ))))
        :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
          (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
            $ (CONST_INT 8)
           ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
              (Poly%curve25519_dalek!window.LookupTable. self!)
           )))
          ) j$
        ))
        :qid user_curve25519_dalek__window__LookupTable__select_114
        :skolemid skolem_user_curve25519_dalek__window__LookupTable__select_114
   )))))
   :pattern ((req%curve25519_dalek!window.impl&%6.select. self! x!))
   :qid internal_req__curve25519_dalek!window.impl&__6.select._definition
   :skolemid skolem_internal_req__curve25519_dalek!window.impl&__6.select._definition
)))
(declare-fun ens%curve25519_dalek!window.impl&%6.select. (curve25519_dalek!window.LookupTable.
  Int curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!window.LookupTable.) (x! Int) (result! curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
  (!
   (= (ens%curve25519_dalek!window.impl&%6.select. self! x! result!) (and
     (has_type (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. result!)
      TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
     )
     (=>
      (> x! 0)
      (= result! (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!seq.Seq.index.?
         $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
          $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. $ (
            CONST_INT 8
           )
          ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
             (Poly%curve25519_dalek!window.LookupTable. self!)
          )))
         ) (I (Sub x! 1))
     ))))
     (=>
      (= x! 0)
      (= result! (curve25519_dalek!specs.edwards_specs.identity_affine_niels.? (I 0)))
     )
     (=>
      (< x! 0)
      (= result! (curve25519_dalek!specs.edwards_specs.negate_affine_niels.? (vstd!seq.Seq.index.?
         $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
          $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. $ (
            CONST_INT 8
           )
          ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
             (Poly%curve25519_dalek!window.LookupTable. self!)
          )))
         ) (I (Sub (Sub 0 x!) 1))
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
        (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
        (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
        (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
       result!
   ))))
   :pattern ((ens%curve25519_dalek!window.impl&%6.select. self! x! result!))
   :qid internal_ens__curve25519_dalek!window.impl&__6.select._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__6.select._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_affine_niels_affine_equals_edwards_affine
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_niels_affine_equals_edwards_affine.
 (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. curve25519_dalek!edwards.EdwardsPoint.)
 Bool
)
(declare-const %%global_location_label%%51 Bool)
(declare-const %%global_location_label%%52 Bool)
(assert
 (forall ((niels! curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.) (point!
    curve25519_dalek!edwards.EdwardsPoint.
   )
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_niels_affine_equals_edwards_affine.
     niels! point!
    ) (and
     (=>
      %%global_location_label%%51
      (curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.? (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
        niels!
       ) (Poly%curve25519_dalek!edwards.EdwardsPoint. point!)
     ))
     (=>
      %%global_location_label%%52
      (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        point!
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_niels_affine_equals_edwards_affine.
     niels! point!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_niels_affine_equals_edwards_affine._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_niels_affine_equals_edwards_affine._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_niels_affine_equals_edwards_affine.
 (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. curve25519_dalek!edwards.EdwardsPoint.)
 Bool
)
(assert
 (forall ((niels! curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.) (point!
    curve25519_dalek!edwards.EdwardsPoint.
   )
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_niels_affine_equals_edwards_affine.
     niels! point!
    ) (= (curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.? (
       Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!
      )
     ) (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       point!
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_niels_affine_equals_edwards_affine.
     niels! point!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_niels_affine_equals_edwards_affine._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_niels_affine_equals_edwards_affine._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::curve_models::impl&%33::add
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%33.add. (Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (other! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%33.add. self! other! result!)
    (and
     (ens%core!ops.arith.Add.add. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. (
       REF $
      ) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. self! other!
      result!
     )
     (curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? result!)
     (= (curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.? result!)
      (let
       ((self_affine$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? self!)))
       (let
        ((other_affine$ (curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?
           other!
        )))
        (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
           (Poly%tuple%2. self_affine$)
          )
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. self_affine$))) (tuple%2./tuple%2/0
          (%Poly%tuple%2. (Poly%tuple%2. other_affine$))
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. other_affine$)))
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%33.add. self! other!
     result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__33.add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__33.add._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Specs curve25519_dalek::edwards::EdwardsPoint::as_affine_niels
(declare-fun req%curve25519_dalek!edwards.impl&%29.as_affine_niels. (curve25519_dalek!edwards.EdwardsPoint.)
 Bool
)
(declare-const %%global_location_label%%53 Bool)
(declare-const %%global_location_label%%54 Bool)
(assert
 (forall ((self! curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (req%curve25519_dalek!edwards.impl&%29.as_affine_niels. self!) (and
     (=>
      %%global_location_label%%53
      (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        self!
     )))
     (=>
      %%global_location_label%%54
      (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        self!
   )))))
   :pattern ((req%curve25519_dalek!edwards.impl&%29.as_affine_niels. self!))
   :qid internal_req__curve25519_dalek!edwards.impl&__29.as_affine_niels._definition
   :skolemid skolem_internal_req__curve25519_dalek!edwards.impl&__29.as_affine_niels._definition
)))
(declare-fun ens%curve25519_dalek!edwards.impl&%29.as_affine_niels. (curve25519_dalek!edwards.EdwardsPoint.
  curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!edwards.EdwardsPoint.) (result! curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
  (!
   (= (ens%curve25519_dalek!edwards.impl&%29.as_affine_niels. self! result!) (and
     (has_type (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. result!)
      TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
     )
     (curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.? (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
       result!
      ) (Poly%curve25519_dalek!edwards.EdwardsPoint. self!)
     )
     (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
       result!
     ))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
        (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
        (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
        (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
          result!
       )))
      ) (I 54)
   )))
   :pattern ((ens%curve25519_dalek!edwards.impl&%29.as_affine_niels. self! result!))
   :qid internal_ens__curve25519_dalek!edwards.impl&__29.as_affine_niels._definition
   :skolemid skolem_internal_ens__curve25519_dalek!edwards.impl&__29.as_affine_niels._definition
)))

;; Function-Specs curve25519_dalek::window::LookupTable::from
(declare-fun ens%curve25519_dalek!window.impl&%13.from. (Poly Poly) Bool)
(assert
 (forall ((P! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!window.impl&%13.from. P! result!) (and
     (ens%core!convert.From.from. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. P! result!
     )
     (curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.? $ (CONST_INT 8)
      (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
         result!
       ))
      ) P! (I 8)
     )
     (curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.? $ (CONST_INT
       8
      ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
         result!
     ))))
     (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? (vstd!seq.Seq.index.?
           $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
            $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. $ (
              CONST_INT 8
             )
            ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
               result!
            )))
           ) j$
       ))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           $ (CONST_INT 8)
          ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
             result!
          )))
         ) j$
       ))
       :qid user_curve25519_dalek__window__LookupTable__from_119
       :skolemid skolem_user_curve25519_dalek__window__LookupTable__from_119
   ))))
   :pattern ((ens%curve25519_dalek!window.impl&%13.from. P! result!))
   :qid internal_ens__curve25519_dalek!window.impl&__13.from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__13.from._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.))
     (has_type result$ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.LookupTable.
        $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
       ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      (F fndef_singleton) closure%$ result$
     )
     (let
      ((P$ (%Poly%curve25519_dalek!edwards.EdwardsPoint. (tuple%1./tuple%1/0 (%Poly%tuple%1.
           closure%$
      )))))
      (and
       (and
        (curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.? $ (CONST_INT 8)
         (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
            result$
          ))
         ) (Poly%curve25519_dalek!edwards.EdwardsPoint. P$) (I 8)
        )
        (curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.? $ (CONST_INT
          8
         ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
            result$
       )))))
       (forall ((j$ Poly)) (!
         (=>
          (has_type j$ INT)
          (=>
           (let
            ((tmp%%$ (%I j$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ 8)
           ))
           (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? (vstd!seq.Seq.index.?
             $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
              $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. $ (
                CONST_INT 8
               )
              ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                 result$
              )))
             ) j$
         ))))
         :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
             $ (CONST_INT 8)
            ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
               result$
            )))
           ) j$
         ))
         :qid user_curve25519_dalek__window__LookupTable__from_120
         :skolemid skolem_user_curve25519_dalek__window__LookupTable__from_120
   ))))))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
     ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__window__LookupTable__from_121
   :skolemid skolem_user_curve25519_dalek__window__LookupTable__from_121
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (TYPE%curve25519_dalek!window.LookupTable.
   $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
  ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Function-Specs curve25519_dalek::edwards::EdwardsPoint::double
(declare-fun req%curve25519_dalek!edwards.impl&%30.double. (curve25519_dalek!edwards.EdwardsPoint.)
 Bool
)
(declare-const %%global_location_label%%55 Bool)
(declare-const %%global_location_label%%56 Bool)
(assert
 (forall ((self! curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (req%curve25519_dalek!edwards.impl&%30.double. self!) (and
     (=>
      %%global_location_label%%55
      (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        self!
     )))
     (=>
      %%global_location_label%%56
      (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        self!
   )))))
   :pattern ((req%curve25519_dalek!edwards.impl&%30.double. self!))
   :qid internal_req__curve25519_dalek!edwards.impl&__30.double._definition
   :skolemid skolem_internal_req__curve25519_dalek!edwards.impl&__30.double._definition
)))
(declare-fun ens%curve25519_dalek!edwards.impl&%30.double. (curve25519_dalek!edwards.EdwardsPoint.
  curve25519_dalek!edwards.EdwardsPoint.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!edwards.EdwardsPoint.) (result! curve25519_dalek!edwards.EdwardsPoint.))
  (!
   (= (ens%curve25519_dalek!edwards.impl&%30.double. self! result!) (and
     (has_type (Poly%curve25519_dalek!edwards.EdwardsPoint. result!) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       result!
     ))
     (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        result!
       )
      ) (curve25519_dalek!specs.edwards_specs.edwards_double.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
         (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
            self!
        ))))
       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
           (Poly%curve25519_dalek!edwards.EdwardsPoint. self!)
   ))))))))
   :pattern ((ens%curve25519_dalek!edwards.impl&%30.double. self! result!))
   :qid internal_ens__curve25519_dalek!edwards.impl&__30.double._definition
   :skolemid skolem_internal_ens__curve25519_dalek!edwards.impl&__30.double._definition
)))

;; Function-Specs curve25519_dalek::window::NafLookupTable5::from
(declare-fun ens%curve25519_dalek!window.impl&%17.from. (Poly Poly) Bool)
(assert
 (forall ((A! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!window.impl&%17.from. A! result!) (and
     (ens%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A! result!
     )
     (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.? (Poly%array%.
       (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
         result!
       ))
      ) A!
     )
     (curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?
      (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
         result!
     ))))
     (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (vstd!seq.Seq.index.?
           $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
            $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             $ (CONST_INT 8)
            ) (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
               result!
            )))
           ) j$
       ))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 8)
          ) (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
             result!
          )))
         ) j$
       ))
       :qid user_curve25519_dalek__window__NafLookupTable5__from_134
       :skolemid skolem_user_curve25519_dalek__window__NafLookupTable5__from_134
   ))))
   :pattern ((ens%curve25519_dalek!window.impl&%17.from. A! result!))
   :qid internal_ens__curve25519_dalek!window.impl&__17.from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__17.from._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.))
     (has_type result$ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable5.
        $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      (F fndef_singleton) closure%$ result$
     )
     (let
      ((A$ (%Poly%curve25519_dalek!edwards.EdwardsPoint. (tuple%1./tuple%1/0 (%Poly%tuple%1.
           closure%$
      )))))
      (and
       (and
        (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.? (Poly%array%.
          (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
            result$
          ))
         ) (Poly%curve25519_dalek!edwards.EdwardsPoint. A$)
        )
        (curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?
         (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
            result$
       )))))
       (forall ((j$ Poly)) (!
         (=>
          (has_type j$ INT)
          (=>
           (let
            ((tmp%%$ (%I j$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ 8)
           ))
           (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (vstd!seq.Seq.index.?
             $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
              $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
               $ (CONST_INT 8)
              ) (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
                 result$
              )))
             ) j$
         ))))
         :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             $ (CONST_INT 8)
            ) (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
               result$
            )))
           ) j$
         ))
         :qid user_curve25519_dalek__window__NafLookupTable5__from_135
         :skolemid skolem_user_curve25519_dalek__window__NafLookupTable5__from_135
   ))))))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable5.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
     ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__window__NafLookupTable5__from_136
   :skolemid skolem_user_curve25519_dalek__window__NafLookupTable5__from_136
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (TYPE%curve25519_dalek!window.NafLookupTable5.
   $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Function-Specs curve25519_dalek::window::NafLookupTable5::from
(declare-fun ens%curve25519_dalek!window.impl&%18.from. (Poly Poly) Bool)
(assert
 (forall ((A! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!window.impl&%18.from. A! result!) (and
     (ens%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A! result!
     )
     (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.? (Poly%array%.
       (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
         result!
       ))
      ) A!
     )
     (curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.? (Poly%array%.
       (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
         result!
   ))))))
   :pattern ((ens%curve25519_dalek!window.impl&%18.from. A! result!))
   :qid internal_ens__curve25519_dalek!window.impl&__18.from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__18.from._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.))
     (has_type result$ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable5.
        $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
       ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      (F fndef_singleton) closure%$ result$
     )
     (let
      ((A$ (%Poly%curve25519_dalek!edwards.EdwardsPoint. (tuple%1./tuple%1/0 (%Poly%tuple%1.
           closure%$
      )))))
      (and
       (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.? (Poly%array%.
         (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
           result$
         ))
        ) (Poly%curve25519_dalek!edwards.EdwardsPoint. A$)
       )
       (curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.? (Poly%array%.
         (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
           result$
   ))))))))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable5.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
     ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__window__NafLookupTable5__from_149
   :skolemid skolem_user_curve25519_dalek__window__NafLookupTable5__from_149
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (TYPE%curve25519_dalek!window.NafLookupTable5.
   $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
  ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Function-Specs curve25519_dalek::window::NafLookupTable8::from
(declare-fun ens%curve25519_dalek!window.impl&%22.from. (Poly Poly) Bool)
(assert
 (forall ((A! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!window.impl&%22.from. A! result!) (and
     (ens%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable8. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A! result!
     )
     (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_projective.? (Poly%array%.
       (curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0 (%Poly%curve25519_dalek!window.NafLookupTable8.
         result!
       ))
      ) A!
     )
     (curve25519_dalek!specs.window_specs.naf_lookup_table8_projective_limbs_bounded.?
      (Poly%array%. (curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0 (%Poly%curve25519_dalek!window.NafLookupTable8.
         result!
   ))))))
   :pattern ((ens%curve25519_dalek!window.impl&%22.from. A! result!))
   :qid internal_ens__curve25519_dalek!window.impl&__22.from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__22.from._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.))
     (has_type result$ (TYPE%curve25519_dalek!window.NafLookupTable8. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable8.
        $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      (F fndef_singleton) closure%$ result$
     )
     (let
      ((A$ (%Poly%curve25519_dalek!edwards.EdwardsPoint. (tuple%1./tuple%1/0 (%Poly%tuple%1.
           closure%$
      )))))
      (and
       (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_projective.? (Poly%array%.
         (curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0 (%Poly%curve25519_dalek!window.NafLookupTable8.
           result$
         ))
        ) (Poly%curve25519_dalek!edwards.EdwardsPoint. A$)
       )
       (curve25519_dalek!specs.window_specs.naf_lookup_table8_projective_limbs_bounded.?
        (Poly%array%. (curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0 (%Poly%curve25519_dalek!window.NafLookupTable8.
           result$
   ))))))))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable8.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
     ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__window__NafLookupTable8__from_160
   :skolemid skolem_user_curve25519_dalek__window__NafLookupTable8__from_160
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (TYPE%curve25519_dalek!window.NafLookupTable8. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (TYPE%curve25519_dalek!window.NafLookupTable8.
   $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Function-Specs curve25519_dalek::window::NafLookupTable8::from
(declare-fun ens%curve25519_dalek!window.impl&%23.from. (Poly Poly) Bool)
(assert
 (forall ((A! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!window.impl&%23.from. A! result!) (and
     (ens%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable8. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A! result!
     )
     (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_affine.? (Poly%array%.
       (curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0 (%Poly%curve25519_dalek!window.NafLookupTable8.
         result!
       ))
      ) A!
     )
     (curve25519_dalek!specs.window_specs.naf_lookup_table8_affine_limbs_bounded.? (Poly%array%.
       (curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0 (%Poly%curve25519_dalek!window.NafLookupTable8.
         result!
   ))))))
   :pattern ((ens%curve25519_dalek!window.impl&%23.from. A! result!))
   :qid internal_ens__curve25519_dalek!window.impl&__23.from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__23.from._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.))
     (has_type result$ (TYPE%curve25519_dalek!window.NafLookupTable8. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable8.
        $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
       ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      (F fndef_singleton) closure%$ result$
     )
     (let
      ((A$ (%Poly%curve25519_dalek!edwards.EdwardsPoint. (tuple%1./tuple%1/0 (%Poly%tuple%1.
           closure%$
      )))))
      (and
       (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table8_affine.? (Poly%array%.
         (curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0 (%Poly%curve25519_dalek!window.NafLookupTable8.
           result$
         ))
        ) (Poly%curve25519_dalek!edwards.EdwardsPoint. A$)
       )
       (curve25519_dalek!specs.window_specs.naf_lookup_table8_affine_limbs_bounded.? (Poly%array%.
         (curve25519_dalek!window.NafLookupTable8./NafLookupTable8/0 (%Poly%curve25519_dalek!window.NafLookupTable8.
           result$
   ))))))))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable8.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
     ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__window__NafLookupTable8__from_175
   :skolemid skolem_user_curve25519_dalek__window__NafLookupTable8__from_175
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (TYPE%curve25519_dalek!window.NafLookupTable8. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (TYPE%curve25519_dalek!window.NafLookupTable8.
   $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
  ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::clone
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%1.clone. (Poly Poly)
 Bool
)
(assert
 (forall ((self! Poly) (%return! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%1.clone. self! %return!) (
     and
     (ens%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      self! %return!
     )
     (= %return! self!)
   ))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%1.clone. self! %return!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__1.clone._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__1.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (%return$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.))
     (has_type %return$ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
      (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
      (F fndef_singleton) closure%$ %return$
     )
     (let
      ((self$ (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (tuple%1./tuple%1/0
          (%Poly%tuple%1. closure%$)
      ))))
      (= (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. %return$) self$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (F fndef_singleton) closure%$ %return$
   ))
   :qid user_curve25519_dalek__backend__serial__u64__field__FieldElement51__clone_186
   :skolemid skolem_user_curve25519_dalek__backend__serial__u64__field__FieldElement51__clone_186
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
)

;; Function-Specs curve25519_dalek::backend::serial::curve_models::CompletedPoint::clone
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%7.clone. (Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (%return! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%7.clone. self! %return!)
    (and
     (ens%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
      self! %return!
     )
     (= %return! self!)
   ))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%7.clone. self! %return!))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__7.clone._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__7.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (%return$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.))
     (has_type %return$ TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
      (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
      (F fndef_singleton) closure%$ %return$
     )
     (let
      ((self$ (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. (tuple%1./tuple%1/0
          (%Poly%tuple%1. closure%$)
      ))))
      (= (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. %return$) self$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
     (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
     (F fndef_singleton) closure%$ %return$
   ))
   :qid user_curve25519_dalek__backend__serial__curve_models__CompletedPoint__clone_187
   :skolemid skolem_user_curve25519_dalek__backend__serial__curve_models__CompletedPoint__clone_187
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
)

;; Function-Specs curve25519_dalek::backend::serial::curve_models::ProjectiveNielsPoint::default
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%19.default. (Poly)
 Bool
)
(assert
 (forall ((result! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%19.default. result!) (and
     (ens%core!default.Default.default. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      result!
     )
     (= (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. result!)
      (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%19.default. result!))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__19.default._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__19.default._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type result$ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
      $ TYPE%tuple%0. (F fndef_singleton) closure%$ result$
     )
     (= (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. result$)
      (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? (I 0))
   )))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
     $ TYPE%tuple%0. (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint__default_188
   :skolemid skolem_user_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint__default_188
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
)

;; Function-Specs curve25519_dalek::backend::serial::curve_models::AffineNielsPoint::default
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%21.default. (Poly)
 Bool
)
(assert
 (forall ((result! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%21.default. result!) (and
     (ens%core!default.Default.default. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      result!
     )
     (= (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. result!)
      (curve25519_dalek!specs.edwards_specs.identity_affine_niels.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%21.default. result!))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__21.default._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__21.default._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type result$ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
      $ TYPE%tuple%0. (F fndef_singleton) closure%$ result$
     )
     (= (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. result$)
      (curve25519_dalek!specs.edwards_specs.identity_affine_niels.? (I 0))
   )))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
     $ TYPE%tuple%0. (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint__default_189
   :skolemid skolem_user_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint__default_189
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!clone.Clone. $ (TYPE%curve25519_dalek!window.LookupTable. T&. T&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (TYPE%curve25519_dalek!window.LookupTable. T&.
      T&
   )))
   :qid internal_curve25519_dalek__window__impl&__8_trait_impl_definition
   :skolemid skolem_internal_curve25519_dalek__window__impl&__8_trait_impl_definition
)))

;; Function-Specs curve25519_dalek::window::LookupTable::default
(declare-fun ens%curve25519_dalek!window.impl&%9.default. (Poly) Bool)
(assert
 (forall ((result! Poly)) (!
   (= (ens%curve25519_dalek!window.impl&%9.default. result!) (and
     (ens%core!default.Default.default. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
      result!
     )
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (= (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!seq.Seq.index.?
            $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
             $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. $ (
               CONST_INT 8
              )
             ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                result!
             )))
            ) i$
           )
          ) (curve25519_dalek!specs.edwards_specs.identity_affine_niels.? (I 0))
       )))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           $ (CONST_INT 8)
          ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
             result!
          )))
         ) i$
       ))
       :qid user_curve25519_dalek__window__LookupTable__default_190
       :skolemid skolem_user_curve25519_dalek__window__LookupTable__default_190
   ))))
   :pattern ((ens%curve25519_dalek!window.impl&%9.default. result!))
   :qid internal_ens__curve25519_dalek!window.impl&__9.default._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__9.default._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type result$ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ (TYPE%curve25519_dalek!window.LookupTable.
        $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
       )
      ) $ TYPE%tuple%0. (F fndef_singleton) closure%$ result$
     )
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (= (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!seq.Seq.index.?
            $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
             $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. $ (
               CONST_INT 8
              )
             ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                result$
             )))
            ) i$
           )
          ) (curve25519_dalek!specs.edwards_specs.identity_affine_niels.? (I 0))
       )))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           $ (CONST_INT 8)
          ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
             result$
          )))
         ) i$
       ))
       :qid user_curve25519_dalek__window__LookupTable__default_191
       :skolemid skolem_user_curve25519_dalek__window__LookupTable__default_191
   ))))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      )
     ) $ TYPE%tuple%0. (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__window__LookupTable__default_192
   :skolemid skolem_user_curve25519_dalek__window__LookupTable__default_192
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!default.Default. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
)

;; Function-Specs curve25519_dalek::window::LookupTable::default
(declare-fun ens%curve25519_dalek!window.impl&%10.default. (Poly) Bool)
(assert
 (forall ((result! Poly)) (!
   (= (ens%curve25519_dalek!window.impl&%10.default. result!) (and
     (ens%core!default.Default.default. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
      result!
     )
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (= (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!seq.Seq.index.?
            $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
             $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              $ (CONST_INT 8)
             ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                result!
             )))
            ) i$
           )
          ) (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? (I 0))
       )))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 8)
          ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
             result!
          )))
         ) i$
       ))
       :qid user_curve25519_dalek__window__LookupTable__default_194
       :skolemid skolem_user_curve25519_dalek__window__LookupTable__default_194
   ))))
   :pattern ((ens%curve25519_dalek!window.impl&%10.default. result!))
   :qid internal_ens__curve25519_dalek!window.impl&__10.default._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__10.default._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ TYPE%tuple%0.)
     (has_type result$ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
    )
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ (TYPE%curve25519_dalek!window.LookupTable.
        $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       )
      ) $ TYPE%tuple%0. (F fndef_singleton) closure%$ result$
     )
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (= (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!seq.Seq.index.?
            $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
             $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              $ (CONST_INT 8)
             ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                result$
             )))
            ) i$
           )
          ) (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? (I 0))
       )))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 8)
          ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
             result$
          )))
         ) i$
       ))
       :qid user_curve25519_dalek__window__LookupTable__default_195
       :skolemid skolem_user_curve25519_dalek__window__LookupTable__default_195
   ))))
   :pattern ((closure_ens (FNDEF%core!default.Default.default. $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      )
     ) $ TYPE%tuple%0. (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__window__LookupTable__default_196
   :skolemid skolem_user_curve25519_dalek__window__LookupTable__default_196
)))

;; Function-Def curve25519_dalek::window::LookupTable::default
;; curve25519-dalek/src/window.rs:414:5: 414:63 (#0)
(get-info :all-statistics)
(push)
 (declare-const result! Poly)
 (declare-const tmp%1 Poly)
 (declare-const tmp%2 %%Function%%)
 (assert
  fuel_defaults
 )
 ;; postcondition not satisfied
 (declare-const %%location_label%%0 Bool)
 (assert
  (not (=>
    (ens%curve25519_dalek!backend.serial.curve_models.impl&%19.default. tmp%1)
    (=>
     (closure_ens (FNDEF%core!default.Default.default. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
      $ TYPE%tuple%0. (F fndef_singleton) (Poly%tuple%0. tuple%0./tuple%0) tmp%1
     )
     (=>
      (ens%vstd!array.array_fill_for_copy_types. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       $ (CONST_INT 8) tmp%1 tmp%2
      )
      (=>
       (= result! (Poly%curve25519_dalek!window.LookupTable. (curve25519_dalek!window.LookupTable./LookupTable
          (%Poly%array%. (Poly%array%. tmp%2))
       )))
       (=>
        %%location_label%%0
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ 8)
            ))
            (= (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!seq.Seq.index.?
               $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
                $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                 $ (CONST_INT 8)
                ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                   result!
                )))
               ) i$
              )
             ) (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? (I 0))
          )))
          :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
            (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              $ (CONST_INT 8)
             ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                result!
             )))
            ) i$
          ))
          :qid user_curve25519_dalek__window__LookupTable__default_197
          :skolemid skolem_user_curve25519_dalek__window__LookupTable__default_197
 )))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
